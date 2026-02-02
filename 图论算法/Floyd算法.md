# [2976. 转换字符串的最小成本 I](https://leetcode.cn/problems/minimum-cost-to-convert-string-i/)
给你两个下标从 **0** 开始的字符串 `source` 和 `target` ，它们的长度均为 `n` 并且由 **小写** 英文字母组成。

另给你两个下标从 **0** 开始的字符数组 `original` 和 `changed` ，以及一个整数数组 `cost` ，其中 `cost[i]` 代表将字符 `original[i]` 更改为字符 `changed[i]` 的成本。

你从字符串 `source` 开始。在一次操作中，**如果** 存在 **任意** 下标 `j` 满足 `cost[j] == z`  、`original[j] == x` 以及 `changed[j] == y` 。你就可以选择字符串中的一个字符 `x` 并以 `z` 的成本将其更改为字符 `y` 。

返回将字符串 `source` 转换为字符串 `target` 所需的 **最小** 成本。如果不可能完成转换，则返回 `-1` 。

**注意**，可能存在下标 `i` 、`j` 使得 `original[j] == original[i]` 且 `changed[j] == changed[i]` 。

> NOTE：可以在同一个位置进行连续的变换

```python
class Solution:
    def minimumCost(self, source: str, target: str, original: List[str], changed: List[str], cost: List[int]) -> int:
        # dist[i][j]: cost of changing from char i to char j
        dist = [[inf] * 26 for _ in range(26)]
        for i in range(26):
            dist[i][i] = 0
        for o, c, co in zip(original, changed, cost):
            u = ord(o) - ord('a')
            v = ord(c) - ord('a')
            dist[u][v] = min(dist[u][v], co)
        
        # floyd-warshall 计算所有点对的最短路径
        for k in range(26): # 中间点
            for i in range(26): # 起点
                for j in range(26): # 终点
                    dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
        
        ans = 0
        n = len(source)
        for i in range(n):
            u = ord(source[i]) - ord('a')
            v = ord(target[i]) - ord('a')
            if u == v:
                continue
            if dist[u][v] == inf:
                return -1
            ans += dist[u][v]
        return ans
```

# [2977. 转换字符串的最小成本 II](https://leetcode.cn/problems/minimum-cost-to-convert-string-ii/)
给你两个下标从 **0** 开始的字符串 `source` 和 `target` ，它们的长度均为 `n` 并且由 **小写** 英文字母组成。

另给你两个下标从 **0** 开始的字符串数组 `original` 和 `changed` ，以及一个整数数组 `cost` ，其中 `cost[i]` 代表将字符串 `original[i]` 更改为字符串 `changed[i]` 的成本。

你从字符串 `source` 开始。在一次操作中，**如果** 存在 **任意** 下标 `j` 满足 `cost[j] == z`  、`original[j] == x` 以及 `changed[j] == y` ，你就可以选择字符串中的 **子串** `x` 并以 `z` 的成本将其更改为 `y` 。 你可以执行 **任意数量** 的操作，但是任两次操作必须满足 **以下两个** 条件 **之一** ：

- 在两次操作中选择的子串分别是 `source[a..b]` 和 `source[c..d]` ，满足 `b < c`  **或** `d < a` 。换句话说，两次操作中选择的下标 **不相交** 。
- 在两次操作中选择的子串分别是 `source[a..b]` 和 `source[c..d]` ，满足 `a == c` **且** `b == d` 。换句话说，两次操作中选择的下标 **相同** 。

返回将字符串 `source` 转换为字符串 `target` 所需的 **最小** 成本。如果不可能完成转换，则返回 `-1` 。

**注意**，可能存在下标 `i` 、`j` 使得 `original[j] == original[i]` 且 `changed[j] == changed[i]` 。


思路：
1. 把每个字符串转换成一个整数编号，这一步可以用字典树完成。
2. 建图，从 `original[i]` 向 `changed[i]` 连边，`边权为 cost[i]`。
3. 用 Floyd 算法求图中任意两点最短路，得到 dis 矩阵, 这里得到的 `dis[i][j]` 表示编号为 i 的子串，通过若干次替换操作变成编号为 j 的子串的最小成本。
4. 动态规划。定义 `dfs(i)` 表示从 `source[i]` 开始向后修改的最小成本。
	1. 如果 `source[i]=target[i]`，可以不修改，`dfs(i)=dfs(i+1)`。
	2. 也可以从 `source[i]` 开始向后修改，利用字典树快速判断 source 和 target 的下标从 i 到 j 的子串是否在 original 和 changed 中，如果在就用 `dis[x][y]+dfs(j+1)` 更新 `dfs(i)` 的最小值，其中 x 和 y 分别是 source 和 target 的这段子串对应的编号。
5. 递归边界 `dfs(n)=0`。
6. 递归入口 `dfs(0)`，即为答案。如果答案是无穷大则返回 −1。

```python
class Solution:
    def minimumCost(self, source: str, target: str, original: List[str], changed: List[str], cost: List[int]) -> int:
        len_to_strs = defaultdict(set)
        dist = defaultdict(lambda: defaultdict(lambda: inf))
        for x, y, c in zip(original, changed, cost):
            len_to_strs[len(x)].add(x)
            len_to_strs[len(y)].add(y)
            dist[x][y] = min(dist[x][y], c)
            dist[x][x] = 0
            dist[y][y] = 0
        
        # 不同长度的substr不在同一个连通块里，分别计算连通块内的最短路径(Floyd-Warshall)
        for strs in len_to_strs.values():
            for k in strs:
                for i in strs:
                    if dist[i][k] == inf: # 说明i和k不在同一个连通块里
                        continue
                    for j in strs:
                        dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
        
        n = len(source)
        # dp[i]: 将source[0:i]转换为target[0:i]的最小代价, 如果无法转换则返回inf
        @cache
        def dfs(i: int) -> int:
            # base case
            if i == 0:
                return 0
            res = inf
            if source[i-1] == target[i-1]:
                res = dfs(i-1) # 不改变当前字符
            # 枚举所有可能的子串长度和子串
            for size, strs in len_to_strs.items():
                if i - size < 0:
                    continue
                s = source[i-size:i]
                t = target[i-size:i]
                if s in strs and t in strs: # 说明s和t在同一个连通块里
                    res = min(res, dfs(i-size) + dist[s][t])
            return res
        ans = dfs(n)
        return ans if ans != inf else -1
```