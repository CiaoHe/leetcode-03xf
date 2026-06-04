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