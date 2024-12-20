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
```python fold
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