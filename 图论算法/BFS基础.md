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
- 带(cur_state, step)的BFS
- 每一步考虑可以选择的mutation (或者说：可以转移到的下一个状态)
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
# [1298. 你能从盒子里获得的最大糖果数](https://leetcode.cn/problems/maximum-candies-you-can-get-from-boxes/)
给你 `n` 个盒子，每个盒子的格式为 `[status, candies, keys, containedBoxes]` ，其中：

- 状态字 `status[i]`：整数，如果 `box[i]` 是开的，那么是 **1** ，否则是 **0** 。
- 糖果数 `candies[i]`: 整数，表示 `box[i]` 中糖果的数目。
- 钥匙 `keys[i]`：数组，表示你打开 `box[i]` 后，可以得到一些盒子的钥匙，每个元素分别为该钥匙对应盒子的下标。
- 内含的盒子 `containedBoxes[i]`：整数，表示放在 `box[i]` 里的盒子所对应的下标。

给你一个 `initialBoxes` 数组，表示你现在得到的盒子，你可以获得里面的糖果，也可以用盒子里的钥匙打开新的盒子，还可以继续探索从这个盒子里找到的其他盒子。

请你按照上述规则，返回可以获得糖果的 **最大数目** 。

> BFS + hash
```python
class Solution:
    def maxCandies(self, status: List[int], candies: List[int], keys: List[List[int]], containedBoxes: List[List[int]], initialBoxes: List[int]) -> int:
        q = deque() # 当前可访问+已经开启的盒子
        has, took = set(initialBoxes), set() # 当前拥有的盒子，已经打开的盒子
        ans = 0

        for box in initialBoxes:
            if status[box]:
                q.append(box)
                took.add(box)
                ans += candies[box]

        while q:
            box = q.popleft()
            # 获取盒子中的每一个钥匙
            for k in keys[box]: 
                # 如果钥匙对应的盒子未开启，则开启
                if not status[k]:
                    status[k] = 1
                    # 如果钥匙对应的盒子在拥有的盒子中，并且未打开，则加入队列
                    if k in has and k not in took:
                        q.append(k)
                        took.add(k)
                        ans += candies[k]

            # 获取盒子中的每一个子盒子
            for b in containedBoxes[box]:
                has.add(b)
                # 如果子盒子未打开，则开启
                if b not in took:
                    if status[b]:
                        q.append(b)
                        took.add(b)
                        ans += candies[b]
        return ans
```