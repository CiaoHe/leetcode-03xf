# [373. 查找和最小的 K 对数字](https://leetcode.cn/problems/find-k-pairs-with-smallest-sums/)
思考：
- 先把最小的一批对放入堆中`(nums1[0], nums2[0]), (nums1[0], nums2[1]), (nums1[0], nums2[2])`...
- 然后pop `k`个元素, 用完接着填进去
```python
class Solution:
    def kSmallestPairs(self, nums1: List[int], nums2: List[int], k: int) -> List[List[int]]:
        res = []
        min_heap = []
        # 思考： 先把最小的一批对放入堆中(nums1[0], nums2[0]), (nums1[0], nums2[1]), (nums1[0], nums2[2])...
        # 然后pop k个元素, 用完接着填进去
        m, n = len(nums1), len(nums2)
        for j in range(min(k, n)):
            heappush(min_heap, (nums1[0] + nums2[j], 0, j))
        while len(res) < k:
            _, i, j = heappop(min_heap)
            res.append([nums1[i], nums2[j]])
            if i + 1 < m:
                heappush(min_heap, (nums1[i + 1] + nums2[j], i + 1, j))
        return res
```


# [3691. 最大子数组总值 II](https://leetcode.cn/problems/maximum-total-subarray-value-ii/)
给你一个长度为 `n` 的整数数组 `nums` 和一个整数 `k`。

你必须从 `nums` 中选择 **恰好** `k` 个 **不同** 的非空子数组 `nums[l..r]`。子数组可以重叠，但同一个子数组（相同的 `l` 和 `r`）**不能** 被选择超过一次。

子数组 `nums[l..r]` 的 **值** 定义为：`max(nums[l..r]) - min(nums[l..r])`。

**总值** 是所有被选子数组的 **值** 之和。

返回你能实现的 **最大** 可能总值。

**子数组** 是数组中连续的 **非空** 元素序列。


> 使用最大堆求前K大
> 示例 2 的 nums=[4,2,5,1]，把所有连续子数组的值（极差）算出来，可以得到一个矩阵 M，其中 $M_{l,r}$ 表示子数组 [l,r] 的极差。规定 l>r 时极差为 0。
> $$M = \begin{bmatrix}
0 & 2 & 3 & 4 \\
0 & 0 & 3 & 4 \\
0 & 0 & 0 & 4 \\
0 & 0 & 0 & 0
\end{bmatrix}$$
当左端点固定时，右端点越大，子数组的最小值越小，最大值越大，所以子数组的极差也就越大。
所以矩阵 M 每一行都是递增的。问题相当于：合并 n 个递增列表，计算前 k 大元素之和。

参考[[23. 合并 K 个升序链表](https://leetcode.cn/problems/merge-k-sorted-lists/)](leetcode/链表/分治.md#[23.%20合并%20K%20个升序链表](https%20//leetcode.cn/problems/merge-k-sorted-lists/))  这里使用heap的做法
1. 每次把矩阵每一行的最后一个数 $M_{l,n-1}$ 加入到最大堆里面
2. 循环k次
3. 每次循环 弹出堆顶 把堆顶$M_{l,r}$ 加入到答案里面，再把左边次大元素 $M_{l,r-1}$ 入堆 （如果当前堆顶是0 直接剪枝)

处理的时候我们不能把整个$M$都显式计算出来，而是在构造堆的时候用ST表来计算出来区间最值

```python
def op(a:Tuple[int, int], b:Tuple[int, int]) -> Tuple[int, int]:
    return min(a[0], b[0]), max(a[1], b[1])

# sparse table 用于解决区间最值问题, 预处理时间O(nlogn), 查询时间O(1)。这里我们用来同时维护区间最小值和最大值, 以便求出区间内的差值

# 核心思想：对于长度n的数组 只去维护长度为2^k的区间的最值
# s[i][j] 代表以j为起点 长度为2^i的区间的最值, 即[j, j+2^i)的最值
# 1. 当i=0时, s[0][j] 里面 min和max都等于a[j]
# 2. 当计算长度为2^i的区间时, 可以分成两半，前半部分从j开始，长度为2^(i-1)，对应于st[i-1][j]; 后半部分从j+2^(i-1)开始，长度也为2^(i-1), 对应于st[i-1][j+2^(i-1)]。所以s[i][j] = op(s[i-1][j], s[i-1][j+2^(i-1)])
class ST:
    def __init__(self, a: List[int]):
        n = len(a)
        w = n.bit_length()
        st = [[None] * n for _ in range(w)]
        st[0] = [(x, x) for x in a]
        for i in range(1, w): # i代表区间长度为2^i
            for j in range(n-(1<<i)+1): # j代表区间起点, 需要保证j+2^i-1<n, 即j<n-2^i+1
                st[i][j] = op(st[i-1][j], st[i-1][j+(1<<(i-1))])
        self.st = st
    
    def query(self, l: int, r: int) -> Tuple[int, int]:
        k = (r - l).bit_length() - 1 # 找到最大的2^k满足2^k <= len < 2^(k+1)
        mn, mx = op(self.st[k][l], self.st[k][r-(1<<k)])
        return mx - mn

class Solution:
    def maxTotalValue(self, nums: List[int], k: int) -> int:
        from heapq import heapreplace_max
        n = len(nums)
        st = ST(nums)
        
        # 对于每个起点i, 计算区间[i, n)的差值, 以差值为key, i和n为value, 构建一个大根堆
        h = [(st.query(i, n), i, n) for i in range(n)]

        ans = 0
        for _ in range(k):
            d, l, r = h[0] # 大根堆的根节点是差值最大的区间
            # 一旦使用 就需要弹出来 （因为题目要求每个区间只能使用一次)
            if d == 0: # 差值为0的区间没有价值了, 直接剪枝
                break
            ans += d
            
            # 更新区间, 以l为起点, r-1为终点的区间被使用了, 需要更新为l到r-2的区间
            # ？为什么我们不压入[l+1, r)的区间呢？因为我们每次都是从左边开始使用区间的, 所以我们只需要更新右边界就行了, 左边界不变]
            heapreplace_max(h, (st.query(l, r-1), l, r-1))
        return ans
```