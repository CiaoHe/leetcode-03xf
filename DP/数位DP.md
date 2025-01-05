# [60. 排列序列](https://leetcode.cn/problems/permutation-sequence/)
雏形渐露：
- 对于n位数字，假设我们已经确定了前`i`位，那么后面共有多少种选择的可能性 (我们计作cnt) = `(n-1-i)!`
- 对于第`i`位，我们假设所有未访问的数字都可以作为第`i`位
假定对于第`i`位我们选择的数字是`x`
1. 如果`cnt >= k`, 那么证明我们要找的第`k`个排列就在 当前以`x`为结尾的前缀（树）中
2. 否则，`cnt < k`, 那么证明我们要找的第`k`个排列不在 当前以`x`为结尾的前缀（树）中，所以需要继续判定下一个可能的`x`

```python
class Solution:
    def getPermutation(self, n: int, k: int) -> str:
        if n == 0:
            return ""

        visited = set()
        path = []

        # 预处理：提前计算好 (n-1-i)! for i in range(n): 也就是factorial(0,1,...,n-1)
        factorial = [1] * (n+1) # 我们希望取factorial[i] = i!, 特此多开了一个空间
        for i in range(2, n+1):
            factorial[i] = factorial[i-1] * i
        
        def dfs(i, k):
            if i == n: # 如果已经确定了n位，那么直接返回
                return
            cnt = factorial[n-1-i] # 后面共有多少种选择的可能性
            # 对于第i位，我们假设所有未访问的数字都可以作为第i位
            for x in range(1, n+1):
                if x in visited:
                    continue
                if cnt < k: # 如果cnt < k, 那么证明我们要找的第k个排列不在 当前以x为结尾的前缀（树）中, 所以需要继续判定下一个可能的x
                    k -= cnt
                    continue
                # 如果cnt >= k, 那么证明我们要找的第k个排列就在 当前以x为结尾的前缀（树）中
                path.append(x)
                visited.add(x)
                dfs(i+1, k)
                return
            
        dfs(0, k)
        return "".join(map(str, path))
```