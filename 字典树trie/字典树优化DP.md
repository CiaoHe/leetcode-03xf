# [440. 字典序的第K小数字](https://leetcode.cn/problems/k-th-smallest-in-lexicographical-order/)
树形DP
掌握十叉树的特点
```python
class Solution:
    def findKthNumber(self, n: int, k: int) -> int:
        def check(root:int)->int:
            # 计算root中有多少不超过n的数
            res = 0
            # 每一层的开头和结尾我们标记为start和end
            start, end = root, root
            while start <= n:
                # 这一层可以有多少个有效数字
                tmp = min(end, n) - start + 1
                res += tmp
                # move 到下一层
                start *= 10
                end = end * 10 + 9
            return res
        
        num = 1
        while k > 1:
            cnt = check(num)
            # 如果以num为根的树中，cnt小于k，说明以num为根的树中没有第k小的数，需要移动到right sibling
            if k > cnt:
                k -= cnt
                num += 1
            # 否则，我们需要在以num为根的树中，下探一层
            else:
                num *= 10
                k -= 1
        return num
```