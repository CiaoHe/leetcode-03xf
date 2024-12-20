# [207. 课程表](https://leetcode.cn/problems/course-schedule/)
## 拓扑排序BFS
```python fold
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        n = numCourses
        # b->a
        g = defaultdict(list)
        for a, b in prerequisites:
            g[a].append(b) # a的先修课有b
        
        # topo sort
        in_degree = [0] * n
        for _, b in prerequisites:
            in_degree[b] += 1
        
        # find 0 in_degree
        q = deque([i for i in range(n) if in_degree[i] == 0])
        count = 0
        while q:
            i = q.popleft()
            count += 1
            for j in g[i]:
                in_degree[j] -= 1
                if in_degree[j] == 0:
                    q.append(j)
        return count == n
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
# [909. 蛇梯棋](https://leetcode.cn/problems/snakes-and-ladders/)
重新翻译： 题目：一个蛇形棋盘，从1走到结尾，每次只能甩骰子1-6，遇到不是-1的值也就是（蛇或者楼梯）可以跳转到相应值的位置，问最少需要几步到达终点。
BFS:
1. 进入之前立好`q` 和 `visited`(已经放进去init)
2. 对于bfs每一步的探索记得及时把合法位置放到visited，做到先visited再展开工作
```python fold
class Solution:
    def snakesAndLadders(self, board: List[List[int]]) -> int:
        n = len(board)
        
        def get_pos(idx: int) -> Tuple[int, int]:
            r = (idx - 1) // n
            c = (idx - 1) % n
            if r % 2 == 0:
                return n - 1 - r, c
            else:
                return n - 1 - r, n - 1 - c
        
        q = deque([(1, 0)])  # (idx, step)
        visited = set([1])
        
        while q:
            idx, step = q.popleft()
            cur_r, cur_c = get_pos(idx)
            
            # Check if the current position is a snake or ladder
            if board[cur_r][cur_c] != -1:
                idx = board[cur_r][cur_c]
            
            # Check if we have reached the end
            if idx == n * n:
                return step
            
            # Move to the next positions
            for next_idx in range(idx + 1, min(idx + 7, n * n + 1)):
                if next_idx not in visited:
                    q.append((next_idx, step + 1))
                    visited.add(next_idx)
        
        return -1
```

# [433. 最小基因变化](https://leetcode.cn/problems/minimum-genetic-mutation/)
## 单向BFS
```python fold
class Solution:
    def minMutation(self, startGene: str, endGene: str, bank: List[str]) -> int:
        if startGene == endGene:
            return 0
        
        choices = "ACGT"
        bank = set(bank)
        q = deque([(startGene, 0)])
        visited = set([startGene])
        while q:
            cur, step = q.popleft()
            if cur == endGene:
                return step
            for i in range(8):
                for choice in choices:
                    next_gene = cur[:i] + choice + cur[i+1:]
                    if next_gene in bank and next_gene not in visited:
                        visited.add(next_gene)
                        q.append((next_gene, step + 1))
        return -1
```
# [127. 单词接龙](https://leetcode.cn/problems/word-ladder/)
与[[#[433. 最小基因变化](https //leetcode.cn/problems/minimum-genetic-mutation/)]]如出一辙
```python fold
class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: List[str]) -> int:
        if endWord not in wordList:
            return 0
        
        wordList = set(wordList)
        q = deque([(beginWord, 1)])
        visited = set([beginWord])
        while q:
            cur, step = q.popleft()
            if cur == endWord:
                return step
            for i in range(len(cur)):
                for c in "abcdefghijklmnopqrstuvwxyz":
                    next_word = cur[:i] + c + cur[i+1:]
                    if next_word in wordList and next_word not in visited:
                        visited.add(next_word)
                        q.append((next_word, step + 1))
        return 0
```
