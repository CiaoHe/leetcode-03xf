例如数组 [1,1,1,2,2]，其中第 1 小、第 2 小和第 3 小的数都是 1，第 4 小和第 5 小的数都是 2。

- 第 k 小等价于：求最小的 x，满足 ≤x 的数至少有 k 个。
- 第 k 大等价于：求最大的 x，满足 ≥x 的数至少有 k 个。
注 1：一般规定 k 从 1 开始，而不是像数组下标那样从 0 开始。
注 2：部分题目也可以用堆解决。

# [2040. 两个有序数组的第 K 小乘积](https://leetcode.cn/problems/kth-smallest-product-of-two-sorted-arrays/)
给你两个 **从小到大排好序** 且下标从 **0** 开始的整数数组 `nums1` 和 `nums2` 以及一个整数 `k` ，请你返回第 `k` （从 **1** 开始编号）小的 `nums1[i] * nums2[j]` 的乘积，其中 `0 <= i < nums1.length` 且 `0 <= j < nums2.length`


- 正确使用
	- bisect_left (lower_bound, close) >=x的最小下标
	- bisect_right (upper_bound, exclude) >x的最小下标

```python
class Solution:
    def kthSmallestProduct(self, nums1: List[int], nums2: List[int], k: int) -> int:
        # l = -max(abs(nums1[0]), abs(nums1[n-1])) x max(abs(nums2[0]), abs(nums2[m-1]))
        # r = -l
        # 每次计算 乘积小于等于p的个数，如果个数小于k，则l = p + 1，否则r = p

        # 关键：如何快速计算乘积小于等于p的个数
        # 枚举nums1中的每个数字x, 分类讨论
        # 1. 如果x>0, x * nums2[i]是单调递增，找到最小的i使得x * nums2[i] > p, 则nums2[0]到nums2[i-1]都满足条件 （+i)
        # 2. 如果x=0, 如果p>=0, 则nums2[0]到nums2[m-1]都满足条件（+m)
        # 3. 如果x<0, x * nums2[i]是单调递减，找到最小的i使得x * nums2[i] <= p, 则nums2[i+1]到nums2[m-1]都满足条件（+m-i-1)

        def count(p):
            cnt = 0
            m = len(nums2)
            for x in nums1:
                if x > 0:
                    cnt += bisect_right(nums2, p / x) # bisect_right 返回第一个大于p/x的索引 (i), 那么nums2[0]到nums2[i-1]都满足条件，累计加上i
                elif x == 0:
                    cnt += m * int(p >= 0)
                else:
                    i = bisect_left(nums2, p / x) # bisect_left 返回第一个大于等于p/x的索引 (i), 那么nums2[i]到nums2[m-1]都满足条件，累计加上m-i
                    cnt += m - i
            return cnt
        
        mx = max(abs(nums1[0]), abs(nums1[-1])) * max(abs(nums2[0]), abs(nums2[-1]))
        l, r = -mx, mx
        while l < r:
            mid = (l + r) // 2
            if count(mid) < k:
                l = mid + 1
            else:
                r = mid
        return l
```