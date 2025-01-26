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