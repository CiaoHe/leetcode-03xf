# [2920. 收集所有金币可获得的最大积分](https://leetcode.cn/problems/maximum-points-after-collecting-coins-from-all-nodes/)
- 选择第二种 等价于 右移1位
- 设计子问题： `dfs(i,j)`: 从i出发，选择右移j位，能获得的最大值
- 选择第一种
	- `dfs(i,j) = (coins[i]>>j) - k + sum(dfs(ch, j) for ch in g[i])`
- 选择第二种
	- `dfs(i,j) = (coins[i]>>j+1) + sum(dfs(ch, j+1) for ch in g[i])`
```python
class Solution:
    def maximumPoints(self, edges: List[List[int]], coins: List[int], k: int) -> int:
        g = defaultdict(list)
        for u, v in edges:
            g[u].append(v)
            g[v].append(u)
            
        @lru_cache(None)
        def dfs(i, j, fa):
            # 设置fa防止回溯回去
            res1 = (coins[i]>>j) - k 
            res2 = (coins[i]>>j+1)
            for ch in g[i]:
                if ch == fa:
                    continue
                res1 += dfs(ch, j, i)
                # 本题范围内，coins[i]的二进制表示最多有14位
                if j < 14:
                    res2 += dfs(ch, j+1, i)
            return max(res1, res2)
        return dfs(0, 0, -1)
```