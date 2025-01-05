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