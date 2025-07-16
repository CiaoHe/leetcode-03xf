# [1561. 你可以获得的最大硬币数目](https://leetcode.cn/problems/maximum-number-of-coins-you-can-get/)
- 前面那1/3部分都给bob, 后面的部分每个pair只能取第二个
```python
class Solution:
    def maxCoins(self, piles: List[int]) -> int:
        piles.sort()
        n = len(piles)
        res = 0
        for i in range(n//3, n, 2):
            res += piles[i]
        return res
```
# [2412. 完成所有交易的初始最少钱数](https://leetcode.cn/problems/minimum-money-required-before-transactions/)
最坏的情况：先完成所有亏钱的，再完成赚钱的
1. 先计算出`total_lose`
2. 对于亏钱交易，假设cost, 那么需要满足init_money - total_lose >= cost
3. 对于赚钱交易，假设cost, 那么需要满足init_money - (total_lose - (cost - cashback)) >= cost , 等价于init_money - total_lose >= cashback
```python
class Solution:
    def minimumMoney(self, transactions: List[List[int]]) -> int:
        total_lose = 0
        for cost, cashback in transactions:
            if cost > cashback:
                total_lose += cost - cashback
        # 1. 对于亏钱交易，假设cost, 那么需要满足init_money - total_lose >= cost
        # 2. 对于赚钱交易，假设cost, 那么需要满足init_money - (total_lose - (cost - cashback)) >= cost 
        # 等价于init_money - total_lose >= cashback
        max_cost = 0
        for cost, cashback in transactions:
            max_cost = max(max_cost, min(cost, cashback))
        return total_lose + max_cost
```
# [3440. 重新安排会议得到最多空余时间 II](https://leetcode.cn/problems/reschedule-meetings-for-maximum-free-time-ii/)
给你一个整数 `eventTime` 表示一个活动的总时长，这个活动开始于 `t = 0` ，结束于 `t = eventTime` 。

同时给你两个长度为 `n` 的整数数组 `startTime` 和 `endTime` 。它们表示这次活动中 `n` 个时间 **没有重叠** 的会议，其中第 `i` 个会议的时间为 `[startTime[i], endTime[i]]` 。

你可以重新安排 **至多** 一个会议，安排的规则是将会议时间平移，且保持原来的 **会议时长** ，你的目的是移动会议后 **最大化** 相邻两个会议之间的 **最长** 连续空余时间。

请你返回重新安排会议以后，可以得到的 **最大** 空余时间。

**注意**，会议 **不能** 安排到整个活动的时间以外，且会议之间需要保持互不重叠。

**注意：**重新安排会议以后，会议之间的顺序可以发生改变。

```python
class Solution:
    def maxFreeTime(self, eventTime: int, startTime: List[int], endTime: List[int]) -> int:
        n = len(startTime) # 会议数目

        # 计算目前的空位长度
        def get(i:int):
            if i==0:
                return startTime[0]
            if i==n:
                return eventTime - endTime[-1]
            return startTime[i] - endTime[i-1]
        
        # 当前有n+1个空位(假设)，计算当前 max3 space
        a, b, c = 0, -1, -1
        for i in range(1, n+1):
            sz = get(i)
            # update a,b,c
            if sz > get(a):
                a, b, c = i, a, b
            elif b<0 or sz > get(b):
                b, c = i, b
            elif c<0 or sz > get(c):
                c = i
        ans = 0
        # 枚举现在的会议
        for i, (st, ed) in enumerate(zip(startTime, endTime)):
            dur = ed - st
            if i!=a and i+1!=a and dur<=get(a) or \
                i!=b and i+1!=b and dur<=get(b) or \
                dur<=get(c): # 可以被放在最大gap / 次大gap / 次次大gap
                # 现在这个会议可以被移走
                ans = max(ans, get(i)+dur+get(i+1)) # dur + 左右两端空位长度
            else:
                ans = max(ans, get(i)+get(i+1)) # 左右两端空位长度
        
        return ans        
```