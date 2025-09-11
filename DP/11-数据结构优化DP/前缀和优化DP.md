# [3251. 单调数组对的数目 II](https://leetcode.cn/problems/find-the-count-of-monotonic-pairs-ii/)
```python fold

# consider to enumerate all possible values for k:=arr1[i-1],
# 1. since arr1[i-1] <= j and arr2[i-1] >= j
#    then we get k<=j and nums[i-1]-k>=nums[i]-j
#    further, we get max_k = min(j, nums[i-1]-nums[i]+j) = j + min(0, nums[i-1]-nums[i])s

# 2. we get f[i][j] = sum(f[i-1][k]) for k in range(j+min(0, nums[i-1]-nums[i])+1)
	# maybe we can use prefix sum to optimize the sum

class Solution:
    def countOfPairs(self, nums: List[int]) -> int:
        n = len(nums)
        mx = max(nums)
        MOD = 10**9 + 7
        f = [[0] * (mx+1) for _ in range(n)]
        # pre set f[0][j]=1 for j <= nums[0]
        for j in range(nums[0]+1):
            f[0][j] = 1
        for i in range(1, n):
            # 提前用前缀和优化：计算f[i][...]时已经与f[i-1][...]无关
            s = list(accumulate(f[i-1]))
            for j in range(nums[i]+1):
                max_k = j + min(0, nums[i-1]-nums[i]) # 可能为负数
                f[i][j] = s[max_k] % MOD if max_k >= 0 else 0
        return sum(f[n-1]) % MOD
```

# [3333. 找到初始输入字符串 II](https://leetcode.cn/problems/find-the-original-typed-string-ii/)
Alice 正在她的电脑上输入一个字符串。但是她打字技术比较笨拙，她 **可能** 在一个按键上按太久，导致一个字符被输入 **多次** 。
给你一个字符串 `word` ，它表示 **最终** 显示在 Alice 显示屏上的结果。同时给你一个 **正** 整数 `k` ，表示一开始 Alice 输入字符串的长度 **至少** 为 `k` 。
请你返回 Alice 一开始可能想要输入字符串的总方案数。
由于答案可能很大，请你将它对 `109 + 7` **取余** 后返回。


1. 长度至少为 k，可以拆分成两个子问题：
	1. 长度不限制，那么每一组连续相同字符的长度都可以选择 1 到该组长度的任意一个字符，假设方案数为 a。
	2. 长度小于 k，假设方案数为 b。
	那么最终的方案数为 a−b。
2. 我们可以将字符串 word 中连续相同的字符分组，由于每组至少选择一个字符，因此，如果一组剩余可选字符大于 0，我们将其加入到一个数组 nums 中。初始选完每一组之后，我们更新剩余的可选字符数 k
	1. 如果 k<1，说明选择每一组的一个字符后，已经满足长度至少为 k 的要求，此时答案为 a
	2. 否则，我们需要计算 b 的值。我们使用一个二维数组 f，其中 `f[i][j]` 表示前 i 组字符中，选择 j 个字符的方案数。初始时 `f[0][0]=1`，表示没有字符时，选择 0 个字符的方案数为 1。那么 $b = \sum_{j=0}^{k=1}f[m][j]$ 其中 m 为 nums 的长度。答案为 a−b
		1. 考虑用前缀和来优化计算b

```python
class Solution:
    def possibleStringCount(self, word: str, k: int) -> int:
        n = len(word)
        MOD = 10**9 + 7
        # 把word中连续相同的字符分组，每组至少选择一个字符
        # 如果一个组 剩余可选字符的个数>0, 那么把[剩余可选字符的个数: repeat times - 1]放到nums中
        # 初始选完每个组之后，更新剩余的可选字符数量k
        nums = []
        ans = 1
        cur = 0 # 记录当前连续相同字符的repeat times
        for i,c in enumerate(word):
            cur += 1
            if i == n-1 or c != word[i+1]:
                if cur > 1:
                    if k>0: # 还可以进行一次压缩
                        nums.append(cur - 1)
                    # 排列
                    ans = ans * cur % MOD
                cur = 0
                k -= 1
        
        if k<1: # 已经没有可压缩的余地
            return ans

        m = len(nums)
        dp = [[0]*k for _ in range(m+1)]
        # dp[i][j] 表示前i个组中，恰好使用j次压缩(删除j个重复字符)的方案数目
        dp[0][0] = 1 # 啥也不选, default=1
        for i, x in enumerate(nums, 1):
            s = list(accumulate(dp[i-1], initial=0)) 
            # s[j] 表示 dp[i-1][0] + dp[i-1][1] + ... + dp[i-1][j-1]。
            for j in range(k):
                dp[i][j] = (s[j+1] - s[j - min(j, x)]) % MOD
                # s[j + 1] - s[j - min(x, j)] 计算的是 dp[i-1][j - x] + ... + dp[i-1][j]
        
        return (ans - sum(dp[m][j] for j in range(k))) % MOD
```

# [2327. 知道秘密的人数](https://leetcode.cn/problems/number-of-people-aware-of-a-secret/)
在第 `1` 天，有一个人发现了一个秘密。

给你一个整数 `delay` ，表示每个人会在发现秘密后的 `delay` 天之后，**每天** 给一个新的人 **分享** 秘密。同时给你一个整数 `forget` ，表示每个人在发现秘密 `forget` 天之后会 **忘记** 这个秘密。一个人 **不能** 在忘记秘密那一天及之后的日子里分享秘密。

给你一个整数 `n` ，请你返回在第 `n` 天结束时，知道秘密的人数。由于答案可能会很大，请你将结果对 `109 + 7` **取余** 后返回。

根据题意，任意一天你在银行的资产都可以分为：
- A 类：可以产生利息的钱；
- B 类：尚不能产生利息的钱；(cntb)
- C 类：停止产生利息的钱（不参与计算）。

定义 f\[i] 表示第 i 天的 A 类钱数，这也等价于第 i 天产生了 f\[i] 的利息，这些利息又可以在第 \[i+delay,i+forget) 天产生新的利息。因此，我们可以用 f\[i] 去更新后续的 f\[j]，把 j 在区间 \[i+delay,i+forget) 内的 f\[j] 都加上 f\[i]。

```python
class Solution:
    def peopleAwareOfSecret(self, n: int, delay: int, forget: int) -> int:
        MOD = 10**9 + 7
        f = [0] * n
        f[0] = 1
        cnt_b = 0
        for i, x in enumerate(f):
            if i + delay >= n:
                cnt_b += x
            for j in range(i+delay, min(i+forget, n)):
                f[j] = (f[j] + x) % MOD
        return (f[-1] + cnt_b) % MOD
```

# [1871. 跳跃游戏 VII](https://leetcode.cn/problems/jump-game-vii/)
给你一个下标从 **0** 开始的二进制字符串 `s` 和两个整数 `minJump` 和 `maxJump` 。一开始，你在下标 `0` 处，且该位置的值一定为 `'0'` 。当同时满足如下条件时，你可以从下标 `i` 移动到下标 `j` 处：

- `i + minJump <= j <= min(i + maxJump, s.length - 1)` 且
- `s[j] == '0'`.

如果你可以到达 `s` 的下标 `s.length - 1` 处，请你返回 `true` ，否则返回 `false` 。


oom
```python
class Solution:
    def canReach(self, s: str, minJump: int, maxJump: int) -> bool:
        n = len(s)
        f = [False] * n
        f[0] = True
        for i in range(1, n):
            if s[i] == '0':
                for j in range(max(0, i-maxJump), i-minJump+1):
                    if f[j]:
                        f[i] = True
                        break
        return f[-1]
```
用一个计数器 记录在当前窗口[i-maxJump, i-minJump]内能到达的点的个数

1. 我们从左到右遍历 i。
2. 当 i 向右移动时，窗口 [i-maxJump, i-minJump] 也随之向右滑动。
3. 在计算 f[i] 之前，我们先更新 reachable_count：
    - 检查刚刚进入窗口右边界的元素 f[i - minJump]。如果它是 True，则 reachable_count 加一。
    - 检查刚刚滑出窗口左边界的元素 f[i - maxJump - 1]。如果它是 True，则 reachable_count 减一。
4. 这样，在 O(1) 的时间内更新完 reachable_count 后，我们只需要判断 reachable_count > 0 并且 s[i] == '0'，就可以知道 f[i] 是否可达。
```python
class Solution:
    def canReach(self, s: str, minJump: int, maxJump: int) -> bool:
        n = len(s)
        f = [False] * n
        f[0] = True

        reach_cnt = 0 # 记录在当前窗口[i-maxJump, i-minJump]内能到达的点的个数
        for i in range(1, n):
	        # 
            if i - minJump >= 0 and f[i-minJump]:
                reach_cnt += 1
            if i - (maxJump + 1) >= 0 and f[i-(maxJump + 1)]:
                reach_cnt -= 1
            if reach_cnt > 0 and s[i] == '0':
                f[i] = True
        return f[-1]
```
# [3473. 长度至少为 M 的 K 个子数组之和](https://leetcode.cn/problems/sum-of-k-subarrays-with-length-at-least-m/)
给你一个整数数组 nums 和两个整数 k 和 m。
返回数组 nums 中 k 个不重叠子数组的 最大 和，其中每个子数组的长度 至少 为 m。
子数组 是数组中的一个连续序列。

oom  O(k * n³)
```python
class Solution:
    def maxSum(self, nums: List[int], k: int, m: int) -> int:
        n = len(nums)
        # f[i][j]: max sum with i subarrays for the first j elements
        # i的范围: 0~k
        # j的范围: 0~n-1
        f = [[-inf] * (n+1) for _ in range(k+1)]
        f[0][0] = 0
        # 枚举子数组个数
        for i in range(1, k+1):
            for j in range(1, n+1):
                f[i][j] = f[i][j-1]
                # 第i个子数组以j-1结尾，那么起点l必须满足j-l>=m, 所以l<=j-m
                for l in range(j-m+1):
                    f[i][j] = max(f[i][j], f[i-1][l] + sum(nums[l:j]))
        return f[k][n]
```


前缀和优化计算
```python
class Solution:
    def maxSum(self, nums: List[int], k: int, m: int) -> int:
        n = len(nums)
        # f[i][j]: max sum with i subarrays for the first j elements
        # i的范围: 0~k
        # j的范围: 0~n-1
        f = [[-inf] * (n+1) for _ in range(k+1)]
        # 把边界做好 f[0][j] = 0
        for j in range(n+1):
            f[0][j] = 0
        
        # 为了快速计算nums[l:j]的和，需要预处理前缀和
        s = [0] * (n+1)
        for i in range(1, n+1):
            s[i] = s[i-1] + nums[i-1]

        # 实际上核心转移方程
        # f[i][j] = max(f[i][j-1], max_{0 <= l <= j-m} (f[i-1][l] + s[j] - s[l]))
        # 可以把和l无关的项(s[j])提到外面去
        # f[i][j] = max(f[i][j-1], s[j] + max_{0 <= l <= j-m} (f[i-1][l] - s[l]))

        # 所以我们可以用一个 max_prev来维护 max (f[i-1][l] - s[l])

        for i in range(1, k+1):
            max_prev = -inf
            for j in range(i*m, n+1):
                # option1: 不选以 nums[j-1] 结尾的子数组
                f[i][j] = f[i][j-1]

                # option2: 选以 nums[j-1] 结尾的子数组
                # l 的范围选择在[0, j-m]
                l_candidate = j - m # 新增的l_candidate
                max_prev = max(max_prev, f[i-1][l_candidate] - s[l_candidate])
                f[i][j] = max(f[i][j], s[j] + max_prev)

        return f[k][n]
```