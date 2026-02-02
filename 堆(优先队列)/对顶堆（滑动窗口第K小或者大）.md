也可以用有序集合
# [295. 数据流的中位数](https://leetcode.cn/problems/find-median-from-data-stream/)
假设**小顶堆** A 和 **大顶堆** B：
- A 保存 **较大** 的一半   (bigger)
- B 保存 **较小** 的一半   (smaller)
来了一个新的元素，我想插入A，他有两种情况
- 第一种他比B的堆顶元素大，此时理论上可以直接插入A；
- 第二种情况，他比B的堆顶元素小，此时就不能直接插入A，需要先插入B (维持较小的元素都在B内)，然后取B的堆顶元素插入A

为了简化比较操作，回到第一种情况，可以先统一把元素插入B，
- 然后此时B基于大顶堆的结构特性，会将该元素作为新的堆顶元素，
- 此时再执行插入A的操作就相当于此前在B处过渡了一下，最终还是会插入A 可以理解是代码更简洁，但用堆的自身调整操作替换了比较大小的操作
>[!抽象]
>牛逼的人永远会回到牛逼的队伍


```python
class MedianFinder:

    def __init__(self):
        self.min_heap = []
        self.max_heap = []

    def addNum(self, num: int) -> None:
        # 如果两个堆的size相同，则把num放入min_heap （我们希望min_heap应当和max_heap长度保持差不多，或者多一位）
        # 但是放入一个堆(A)，必须先放入另一个堆(B)，然后从B堆pop一个元素放入A堆
        if len(self.min_heap) == len(self.max_heap):
            heappush(self.min_heap, -heappushpop(self.max_heap, -num))
        else:
            heappush(self.max_heap, -heappushpop(self.min_heap, num))

    def findMedian(self) -> float:
        n = len(self.min_heap) + len(self.max_heap)
        if n % 2 == 1:
            return self.min_heap[0]
        else:
            return (self.min_heap[0] - self.max_heap[0]) / 2
```

# [3013. 将数组分成最小总代价的子数组 II](https://leetcode.cn/problems/divide-an-array-into-subarrays-with-minimum-cost-ii/)
给你一个下标从 **0** 开始长度为 `n` 的整数数组 `nums` 和两个 **正** 整数 `k` 和 `dist` 。

一个数组的 **代价** 是数组中的 **第一个** 元素。比方说，`[1,2,3]` 的代价为 `1` ，`[3,4,1]` 的代价为 `3` 。

你需要将 `nums` 分割成 `k` 个 **连续且互不相交** 的子数组，满足 **第二** 个子数组与第 `k` 个子数组中第一个元素的下标距离 **不超过** `dist` 。换句话说，如果你将 `nums` 分割成子数组 `nums[0..(i1 - 1)], nums[i1..(i2 - 1)], ..., nums[ik-1..(n - 1)]` ，那么它需要满足 `ik-1 - i1 <= dist` 。

请你返回这些子数组的 **最小** 总代价。


第一段的第一个数是确定的，即 `nums[0]`。如果知道了第二段的第一个数的位置（记作 p），第三段的第一个数的位置，……，第 k 段的第一个数的位置（记作 q），那么这个划分方案也就确定了。考虑到 q−p≤dist，本题相当于在一个大小固定为 dist+1 的滑动窗口内，求前 k−1 小的元素和。
可以用两个有序集合来做：
1. 初始化两个有序集合 L 和 R。注意：为方便计算，把 k 减一。
2. 把 `nums[1]` 到 `nums[dist+1]` 加到 L 中。
3. 保留 L 最小的 k 个数，把其余数丢到 R 中。
4. 从 i=dist+2 开始滑窗。
5. 先把 out=nums`[i−dist−1]` 移出窗口：如果 out 在 L 中，就从 L 中移除，否则从 R 中移除。
6. 然后把 in=nums`[i]` 移入窗口：如果 in 小于 L 中的最大元素，则加入 L，否则加入 R。
7. 上面两步做完后，如果 L 中的元素个数小于 k（等于 k−1），则从 R 中取一个最小元素加入 L；反之，如果 L 中的元素个数大于 k（等于 k+1），则从 L 中取一个最大元素加入 R。
上述过程维护 L 中元素之和 sumL，取 sumL 的最小值，即为答案。

```python
class Solution:
    def minimumCost(self, nums: List[int], k: int, dist: int) -> int:
        n = len(nums)
        sum_left = sum(nums[:dist+2])
        L = SortedList(nums[1:dist+2])
        R = SortedList()
        k -= 1

        def L2R() -> None:
            nonlocal sum_left
            x = L.pop() # 最大的数
            sum_left -= x
            R.add(x)

        def R2L() -> None:
            nonlocal sum_left
            x = R.pop(0) # 最小的数
            sum_left += x
            L.add(x)

        while len(L) > k:
            L2R()
        
        ans = sum_left
        for i in range(dist+2, n):
            # 滑动窗口，考虑pop左边的，push右边的
            # 当前窗口左边是i-dist, 右边是i-1.
            # 我们需要向前移动，所以左端点i-dist-1需要出去，i需要进来
            out = nums[i-dist-1] 
            if out in L:
                sum_left -= out
                L.remove(out)
            else:
                R.remove(out)
            
            in_ = nums[i]
            if in_ < L[-1]:
                L.add(in_)
                sum_left += in_
            else:
                R.add(in_)
            
            # 维护大小平衡：
            if len(L) <= k-1:
                R2L()
            elif len(L) > k:
                L2R()
            ans = min(ans, sum_left)
        return ans
```