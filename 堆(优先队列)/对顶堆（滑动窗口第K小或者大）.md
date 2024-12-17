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


```python fold
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