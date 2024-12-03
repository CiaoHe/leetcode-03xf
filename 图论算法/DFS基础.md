# [207. 课程表](https://leetcode.cn/problems/course-schedule/)
## 拓扑排序BFS
```python fold
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        g = defaultdict(list)
        for course, pre in prerequisites:
            g[pre].append(course)
        n = numCourses
        # topological sort

        # leaf node
        leaves = []
        for course in range(n):
            if course not in g:
                leaves.append(course)

        visited = set()
        while leaves:
            course = leaves.pop()
            visited.add(course)
            for pre in g:
                if course in g[pre]:
                    g[pre].remove(course)
                    if len(g[pre]) == 0:
                        leaves.append(pre)
        
        return len(visited) == n
```
## 三色标记法
dfs来判断是否有环
```python fold
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        g = defaultdict(list)
        for course, pre in prerequisites:
            g[pre].append(course)

        # 染色法：0-未访问，1-访问中，2-访问完成
        visited = [0] * numCourses

        # 返回是否存在环
        def dfs(course)->bool:
            visited[course] = 1 # 访问中
            for pre in g[course]:
                # 访问中，存在环
                if visited[pre] == 1:
                    return True
                # 未访问, 递归访问，存在环
                if visited[pre] == 0 and dfs(pre):
                    return True
            visited[course] = 2 # 访问完成
            return False

        for course in range(numCourses):
            if visited[course] == 0 and dfs(course):
                return False
        return True
```