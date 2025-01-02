# [440. 字典序的第K小数字](https://leetcode.cn/problems/k-th-smallest-in-lexicographical-order/)
树形DP
掌握十叉树的特点
```python
class Solution:
    def findKthNumber(self, n: int, k: int) -> int:
        def check(root:int)->int:
            # 计算root中有多少不超过n的数
            res = 0
            # 每一层最小和最大我们标记为 mn_val 和 mx_val
            mn_val, mx_val = root, root
            while mn_val <= n:
                # 这一层可以有多少个有效数字
                res += min(mx_val, n) - mn_val + 1
                # move 到下一层
                mn_val *= 10
                mx_val = mx_val * 10 + 9
            return res
        
        num = 1
        while k > 1:
            cnt = check(num)
            # 如果以num为根的树中，cnt小于k，说明以num为根的树中没有第k小的数(不够k个)，需要移动到right sibling
            if k > cnt:
                k -= cnt
                num += 1
            # 否则，我们需要在以num为根的树中，下探一层: k的取值应当收缩
            else:
	            k -= 1
                num *= 10
        return num
```
可以进一步把check写成dfs形式
```python
def check(l:int,r:int)->int:
	# 以l开头 不超过r 一共有多少个数
	if l>n:
		return 0
	return min(n,r)-l+1 + check(l*10,r*10+9)
```