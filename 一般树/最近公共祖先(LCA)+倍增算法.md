# [1483. 树节点的第 K 个祖先](https://leetcode.cn/problems/kth-ancestor-of-a-tree-node/) 模版题

给你一棵树，树上有 `n` 个节点，按从 `0` 到 `n-1` 编号。树以父节点数组的形式给出，其中 `parent[i]` 是节点 `i` 的父节点。树的根节点是编号为 `0` 的节点。

树节点的第 _`k`_ 个祖先节点是从该节点到根节点路径上的第 `k` 个节点。

实现 `TreeAncestor` 类：

- `TreeAncestor（int n， int[] parent）` 对树和父数组中的节点数初始化对象。
- `getKthAncestor``(int node, int k)` 返回节点 `node` 的第 `k` 个祖先节点。如果不存在这样的祖先节点，返回 `-1` 。


1. 对于lca 模版来说 `pa[x][0]=parent[x]`，即父节点。
2. `pa[x][1]=pa[pa[x][0]][0]`  `pa[x][1]` 代表x的2^1的父节点=祖父节点, 那么`pa[x][0]`就是父节点，那么`pa[pa[x][0]][0]`就是父节点的父节点 
3. 更general一点如何转移? `pa[x][i+1] = pa[ pa[x][i]][i]` 因为 `2^i + 2^i = 2^(i+1)步` 

```python
class TreeAncestor:
    def __init__(self, n: int, parent: List[int]):
        m = n.bit_length() - 1 # floor(log2(n))
        pa = [ [p] + [-1]*m for p in parent]
        # 如果parent是[-1,0,0,1,2]
        """
        pa = [
            [-1, -1, -1, -1],   # 节点0：父节点=-1，2^0,2^1,2^2祖先未知
            [ 0, -1, -1, -1],   # 节点1：父节点=0
            [ 0, -1, -1, -1],   # 节点2：父节点=0
            [ 1, -1, -1, -1],   # 节点3：父节点=1
            [ 2, -1, -1, -1],   # 节点4：父节点=2
        ]
        """
        for i in range(m):
            for x in range(n):
                p = pa[x][i]
                if p != -1:
                    pa[x][i+1] = pa[p][i]
        self.pa = pa

    def getKthAncestor(self, node: int, k: int) -> int:
        # 我们需要对k进行二进制拆分，找到对应的祖先
        for i in range(k.bit_length()):
            if (k>>i) & 1: # 如果k的第i位是1，我们就需要往上跳2^i步
                node = self.pa[node][i]
                if node == -1:
                    break
        return node

```

# 任意两点x和y的lca

假设 depth[x]≤depth[y]（否则交换两点）。我们可以先把更靠下的 y 更新为 y 的第 depth[y]−depth[x] 个祖先节点，这样 x 和 y 就处在同一深度了。

因为我们不知道lca的具体位置，只能先大步跳  (len(pa)-1) -> 小步跳 (0)
-  如果 x 的第 2^i 个祖先节点不存在，即 `pa[x][i]=−1`，说明步子迈大了，将 i 减 1，继续循环。
- 如果 x 的第 2^i 个祖先节点存在 (`pa[x][i]!=-1`) 
	- 如果 `pa[x][i] != pa[y][i]` 那么lca还在 `pa[x][i]`上面，更新 `x = pa[x][i]` （跳上去），y也跟着跳上去（`y = pa[y][i]`）. i-=1
	- 如果`pa[x][i] == pa[y][i]` 那么证明跳过了（`pa[x][i]`在lca上面了） 需要换小步子 
> 上述做法能跳就尽量跳，不会错过任何可以上跳的机会
 循环结束时，x 与 lca 只有一步之遥，即 `lca=pa[x][0]`

```python
class TreeAncestor:
    def __init__(self, edges: List[List[int]]):
        n = len(edges) + 1
        m = n.bit_length()
        g = [[] for _ in range(n)]
        for u, v in edges:
            g[u].append(v)
            g[v].append(u)
        
        depth = [0] * n # 记录每个节点的深度
        pa = [[-1] * m for _ in range(n)] # pa[i][j] 记录节点i的第2^j个祖先
        def dfs(x:int, fa:int)->None:
            pa[x][0] = fa # 记录父节点
            for y in g[x]:
                if y == fa:
                    continue
                depth[y] = depth[x] + 1
                dfs(y, x)
        dfs(0, -1)

        # 来更新pa
        for i in range(m-1):
            for x in range(n):
                p = pa[x][i]
                if p != -1:
                    pa[x][i+1] = pa[p][i]
        
        self.depth = depth
        self.pa = pa

    def getKthAncestor(self, node: int, k: int) -> int:
        for i in range(k.bit_length()):
            if (k >> i) & 1:
                node = self.pa[node][i]
        return node

    def get_lca(self, x:int, y:int) -> int:
        # 先确保depth[x] <= depth[y]
        if self.depth[x] > self.depth[y]:
            x, y = y, x
        
        # 务必先把y提升到和x一样深
        y = self.getKthAncestor(y, self.depth[y] - self.depth[x])
        if x == y:
            return x
        # 同时提升x和y，直到它们的父节点相同
        for i in range(len(self.pa[x])-1, -1, -1):
            px, py = self.pa[x][i], self.pa[y][i]
            if px != py:
                x, y = px, py
        return self.pa[x][0]
```

# [3559. 给边赋权值的方案数 II](https://leetcode.cn/problems/number-of-ways-to-assign-edge-weights-ii/)
[[3558. 给边赋权值的方案数 I](https://leetcode.cn/problems/number-of-ways-to-assign-edge-weights-i/)](自顶向下DFS.md#[3558.%20给边赋权值的方案数%20I](https%20//leetcode.cn/problems/number-of-ways-to-assign-edge-weights-i/)) 进阶题目：把从节点到root -> 任意两节点

给你一棵有 `n` 个节点的无向树，节点从 1 到 `n` 编号，树以节点 1 为根。树由一个长度为 `n - 1` 的二维整数数组 `edges` 表示，其中 `edges[i] = [ui, vi]` 表示在节点 `ui` 和 `vi` 之间有一条边。

一开始，所有边的权重为 0。你可以将每条边的权重设为 **1** 或 **2**。

两个节点 `u` 和 `v` 之间路径的 **代价** 是连接它们路径上所有边的权重之和。

给定一个二维整数数组 `queries`。对于每个 `queries[i] = [ui, vi]`，计算从节点 `ui` 到 `vi` 的路径中，使得路径代价为 **奇数** 的权重分配方式数量。

返回一个数组 `answer`，其中 `answer[i]` 表示第 `i` 个查询的合法赋值方式数量。

由于答案可能很大，请对每个 `answer[i]` 取模 `109 + 7`。

**注意：** 对于每个查询，仅考虑 `ui` 到 `vi` 路径上的边，忽略其他边。

```python
class TreeAncestor:
    def __init__(self, edges: List[List[int]]):
        n = len(edges) + 1
        m = n.bit_length()
        g = [[] for _ in range(n)]
        for u, v in edges:
            u, v = u-1, v-1 # 转成0-indexed
            g[u].append(v)
            g[v].append(u)
        
        depth = [0] * n # 记录每个节点的深度
        pa = [[-1] * m for _ in range(n)] # pa[i][j] 记录节点i的第2^j个祖先
        def dfs(x:int, fa:int)->None:
            pa[x][0] = fa # 记录父节点
            for y in g[x]:
                if y == fa:
                    continue
                depth[y] = depth[x] + 1
                dfs(y, x)
        dfs(0, -1)

        # 来更新pa
        for i in range(m-1):
            for x in range(n):
                p = pa[x][i]
                if p != -1:
                    pa[x][i+1] = pa[p][i]
        
        self.depth = depth
        self.pa = pa

    def getKthAncestor(self, node: int, k: int) -> int:
        for i in range(k.bit_length()):
            if (k >> i) & 1:
                node = self.pa[node][i]
        return node

    def get_lca(self, x:int, y:int) -> int:
        # 先确保depth[x] <= depth[y]
        if self.depth[x] > self.depth[y]:
            x, y = y, x
        
        # 务必先把y提升到和x一样深
        y = self.getKthAncestor(y, self.depth[y] - self.depth[x])
        if x == y:
            return x
        # 同时提升x和y，直到它们的父节点相同
        for i in range(len(self.pa[x])-1, -1, -1):
            px, py = self.pa[x][i], self.pa[y][i]
            if px != py:
                x, y = px, py
        return self.pa[x][0]

    def get_distance(self, x:int, y:int) -> int:
        lca = self.get_lca(x, y)
        return self.depth[x] + self.depth[y] - 2 * self.depth[lca]
    
# 预处理 2 的幂
MOD = 1_000_000_007
POW2 = [0] * 10 ** 5
POW2[0] = 1
for i in range(1, len(POW2)):
    POW2[i] = POW2[i - 1] * 2 % MOD


class Solution:
    def assignEdgeWeights(self, edges: List[List[int]], queries: List[List[int]]) -> List[int]:
        tree = TreeAncestor(edges)
        res = []
        for u, v in queries:
            if u == v:
                res.append(0)
                continue
            log_solutions = tree.get_distance(u-1, v-1)
            res.append(POW2[log_solutions-1])
        return res
```