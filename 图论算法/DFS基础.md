找连通块、判断是否有环（如 207 题）等。部分题目做法不止一种。
```python
def solve(n: int, edges: List[List[int]]) -> List[int]:
    # 节点编号从 0 到 n-1
    g = [[] for _ in range(n)]
    for x, y in edges:
        g[x].append(y)
        g[y].append(x)  # 无向图

    vis = [False] * n

    def dfs(x: int) -> int:
        vis[x] = True  # 避免重复访问节点
        size = 1
        for y in g[x]:
            if not vis[y]:
                size += dfs(y)
        return size

    # 计算每个连通块的大小
    ans = []
    for i, b in enumerate(vis):
        if not b:  # i 没有访问过
            size = dfs(i)
            ans.append(size)
    return ans
```
# [797. 所有可能的路径](https://leetcode.cn/problems/all-paths-from-source-to-target/)
DFS做法
```python
class Solution:
    def allPathsSourceTarget(self, graph: List[List[int]]) -> List[List[int]]:
        n = len(graph)
        g = defaultdict(list)
        for i, v in enumerate(graph):
            g[i].extend(v)
        ans = []
        
        visited = set()
        def dfs(i, path):
            if i==n-1:
                ans.append(path)
                return
            for j in g[i]:
                if j not in visited:
                    visited.add(j)
                    dfs(j, path + [j])
                    visited.remove(j)
        dfs(0, [0])
        return ans
```
BFS做法
```python fold
class Solution:
    def allPathsSourceTarget(self, graph: List[List[int]]) -> List[List[int]]:
        n = len(graph)
        g = defaultdict(list)
        for i, v in enumerate(graph):
            g[i].extend(v)
        ans = []
        
        q = deque([(0, [0])])
        while q:
            i, path = q.popleft()
            if i == n - 1:
                ans.append(path)
            for j in g[i]:
                q.append((j, path + [j]))
        return ans
```

# [133. 克隆图](https://leetcode.cn/problems/clone-graph/)
用DFS去遍历neighbor, 同时用一个hash去做cache（也同时充当visited)
```python
from typing import Optional
class Solution:
    def cloneGraph(self, node: Optional['Node']) -> Optional['Node']:
        self.visited = {}
        def dfs(node):
            if not node:
                return None
            if node in self.visited:
                return self.visited[node]
            new_node = Node(node.val)
            self.visited[node] = new_node
            for neighbor in node.neighbors:
                new_node.neighbors.append(dfs(neighbor))
            return new_node
        return dfs(node)
```
BFS
```python
from typing import Optional
class Solution:
    def cloneGraph(self, node: Optional['Node']) -> Optional['Node']:
        self.visited = {}
        
        def bfs(node):
            if not node:
                return node
            new_node = Node(node.val)
            self.visited[node] = new_node
            
            q = deque([node])
            while q:
                cur = q.popleft()
                for neighbor in cur.neighbors:
                    if neighbor not in self.visited:
                        self.visited[neighbor] = Node(neighbor.val) # register new nb
                        q.append(neighbor)
                    self.visited[cur].neighbors.append(self.visited[neighbor])
            return new_node
        
        return bfs(node)
```

# [1306. 跳跃游戏 III](https://leetcode.cn/problems/jump-game-iii/)
这里有一个非负整数数组 `arr`，你最开始位于该数组的起始下标 `start` 处。当你位于下标 `i` 处时，你可以跳到 `i + arr[i]` 或者 `i - arr[i]`。

请你判断自己是否能够跳到对应元素值为 0 的 **任一** 下标处。

注意，不管是什么情况下，你都无法跳到数组之外。
```python
class Solution:
    def canReach(self, arr: List[int], start: int) -> bool:
        n = len(arr)
        visited = [False] * n
        def dfs(i):
            if i < 0 or i >= n or visited[i]:
                return False
            if arr[i] == 0:
                return True
            visited[i] = True
            return dfs(i + arr[i]) or dfs(i - arr[i])
        return dfs(start)
```
# [1340. 跳跃游戏 V](https://leetcode.cn/problems/jump-game-v/)
给你一个整数数组 `arr` 和一个整数 `d` 。每一步你可以从下标 `i` 跳到：

- `i + x` ，其中 `i + x < arr.length` 且 `0 < x <= d` 。
- `i - x` ，其中 `i - x >= 0` 且 `0 < x <= d` 。

除此以外，你从下标 `i` 跳到下标 `j` 需要满足：`arr[i] > arr[j]` 且 `arr[i] > arr[k]` ，其中下标 `k` 是所有 `i` 到 `j` 之间的数字（更正式的，`min(i, j) < k < max(i, j)`）。

你可以选择数组的任意下标开始跳跃。请你返回你 **最多** 可以访问多少个下标。

请注意，任何时刻你都不能跳到数组的外面。
```python
class Solution:
    def maxJumps(self, arr: List[int], d: int) -> int:
        n = len(arr)
        @cache
        def f(i):
            # f: max jumps starting from i
            res = 1
            for j in range(i-1, max(i-d-1, -1), -1):
                if arr[j] >= arr[i]:
                    break
                res = max(res, f(j) + 1)
            for j in range(i+1, min(i+d+1, n)):
                if arr[j] >= arr[i]:
                    break
                res = max(res, f(j) + 1)
            return res
        return max(f(i) for i in range(n))
```

# [2685. 统计完全连通分量的数量](https://leetcode.cn/problems/count-the-number-of-complete-components/)
给你一个整数 `n` 。现有一个包含 `n` 个顶点的 **无向** 图，顶点按从 `0` 到 `n - 1` 编号。给你一个二维整数数组 `edges` 其中 `edges[i] = [ai, bi]` 表示顶点 `ai` 和 `bi` 之间存在一条 **无向** 边。

返回图中 **完全连通分量** 的数量。

如果在子图中任意两个顶点之间都存在路径，并且子图中没有任何一个顶点与子图外部的顶点共享边，则称其为 **连通分量** 。

如果连通分量中每对节点之间都存在一条边，则称其为 **完全连通分量** 。

> dfs计算联通块大小 + 内部边数
```python
class Solution:
    def countCompleteComponents(self, n: int, edges: List[List[int]]) -> int:
        g = [[] for _ in range(n)]
        for u, v in edges:
            g[u].append(v)
            g[v].append(u)
        vis = [False] * n

        def dfs(x):
            nonlocal v, e
            v += 1 # node num +1
            e += len(g[x])
            vis[x] = True
            for y in g[x]:
                if not vis[y]:
                    dfs(y)
        
        ans = 0
        for i in range(n):
            if not vis[i]:
                v = 0
                e = 0
                dfs(i)
                if e == v * (v - 1):
                    ans += 1
        return ans
```