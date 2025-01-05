# [486. 预测赢家](https://leetcode.cn/problems/predict-the-winner/)
思考：把对方的收益看成是自己的负收益
```python
class Solution:
    def predictTheWinner(self, nums: List[int]) -> bool:
        @lru_cache(None)
        def dfs(l, r):
            if l > r:
                return 0
            if l == r:
                return nums[l]
            # 如果选择l，那么对手会选择l+1或r中的最大值
            # 我们将对手的收益视作-我们的负收益
            return max(nums[l] - dfs(l + 1, r), nums[r] - dfs(l, r - 1))
        return dfs(0, len(nums) - 1) >= 0
```