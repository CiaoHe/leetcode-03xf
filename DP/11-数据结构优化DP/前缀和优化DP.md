2327. 知道秘密的人数 1894
1871. 跳跃游戏 VII 1896 也可以用滑动窗口优化
1997. 访问完所有房间的第一天 2260
3251. 单调数组对的数目 II [[#[3251. 单调数组对的数目 II](https //leetcode.cn/problems/find-the-count-of-monotonic-pairs-ii/)]] 2323 也有组合数学做法
2478. 完美分割的方案数 2344
837. 新 21 点 2350
2463. 最小移动总距离 2454
3333. 找到初始输入字符串 II ~2600 也有生成函数做法
2902. 和带限制的子多重集合的数目 2759
629. K 个逆序对数组
1977. 划分数字的方案数 2817
3130. 找出所有稳定的二进制数组 II 2825 也有组合数学做法

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