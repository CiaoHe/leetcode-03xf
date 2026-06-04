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

# [3075. 幸福值最大化的选择方案](https://leetcode.cn/problems/maximize-happiness-of-selected-children)
给你一个长度为 `n` 的数组 `happiness` ，以及一个 **正整数** `k` 。

`n` 个孩子站成一队，其中第 `i` 个孩子的 **幸福值** 是 `happiness[i]` 。你计划组织 `k` 轮筛选从这 `n` 个孩子中选出 `k` 个孩子。

在每一轮选择一个孩子时，所有 **尚未** 被选中的孩子的 **幸福值** 将减少 `1` 。注意，幸福值 **不能** 变成负数，且只有在它是正数的情况下才会减少。

选择 `k` 个孩子，并使你选中的孩子幸福值之和最大，返回你能够得到的 **最大值** 。

```python
class Solution:
    def maximumHappinessSum(self, happiness: List[int], k: int) -> int:
        ans = 0
        happiness.sort(reverse=True)
        for i in range(k):
            x = happiness[i]
            if x<=i:
                break
            ans += x-i
        return ans
```

# [2144. 打折购买糖果的最小开销](https://leetcode.cn/problems/minimum-cost-of-buying-candies-with-discount/)
一家商店正在打折销售糖果。每购买 **两个** 糖果，商店会 **免费** 送一个糖果。

免费送的糖果唯一的限制是：它的价格需要小于等于购买的两个糖果价格的 **较小值** 。

- 比方说，总共有 `4` 个糖果，价格分别为 `1` ，`2` ，`3` 和 `4` ，一位顾客买了价格为 `2` 和 `3` 的糖果，那么他可以免费获得价格为 `1` 的糖果，但不能获得价格为 `4` 的糖果。

给你一个下标从 **0** 开始的整数数组 `cost` ，其中 `cost[i]` 表示第 `i` 个糖果的价格，请你返回获得 **所有** 糖果的 **最小** 总开销。

```python
class Solution:
    def minimumCost(self, cost: List[int]) -> int:
        cost.sort(reverse=True)
        return sum(cost[i] for i in range(len(cost)) if i % 3 != 2)
```