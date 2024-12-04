Manacher 算法可以计算以 $s[i]$（或者 $s[i]$ 和 $s[i+1]$）为回文中心的最长回文子串的长度。  
此外，还可以：  
- 判断任意子串是否为回文串。  
- 计算从 $s[i]$ 开始的最长回文子串的长度。  
- 计算以 $s[i]$ 结尾的最长回文子串的长度。  
> Z 函数和 Manacher 算法都会用到类似 Z-box 的概念，在学习时，可以对比体会。

# [5. 最长回文子串](https://leetcode.cn/problems/longest-palindromic-substring/)
- 先试试中心扩散
```python fold
class Solution:
    def longestPalindrome(self, s: str) -> str:
        n = len(s)
        if n==1:
            return s
        
        def expand(s, l, r):
            while l>=0 and r<n and s[l] == s[r]:
                l -= 1
                r += 1
            return l+1, r-1
        
        res = ""
        for i in range(n):
            l1, r1 = expand(s, i, i)
            l2, r2 = expand(s, i, i+1)
            if r1-l1 > len(res):
                res = s[l1:r1+1]
            if r2-l2 > len(res):
                res = s[l2:r2+1]
        return res
```

- Manacher 算法

思想：当我们要得到下一个位置i的臂长时，能不能利用之前已经算过的臂长来加速计算？
1. 如果已知 j 的臂长是 length, 并且 `j + length > i `(`i`被包含在以`j`为中心的回文子串内), 那么
	1. 以` i` 为中心的回文子串的臂长至少为 `min(rightmost_j - i, arm_len[i_sym])`,
	2. 至于究竟能扩展到多长还需要自己算
2. 否则，自己算
```python fold
class Solution:
    def longestPalindrome(self, s: str) -> str:
        # 以 i 和 j 为中心扩展回文子串, 返回扩展后的臂长
        def expand(i: int, j: int, s: str) -> int:
            # 以 i 和 j 为中心扩展回文子串
            while i>=0 and j<len(s) and s[i] == s[j]:
                i -= 1
                j += 1
            return (j-i-2) // 2
        
        start, end = 0, -1
        s = "#" + "#".join(s) + "#"
        n = len(s)
        arm_len = [0] * n # 表示以 s[i] 为中心的回文子串的臂长

        rightmost_j = -1 # 当前expand rightmost 的回文子串的右边界下标
        j = -1 # 表示 当前expand rightmost 的回文子串的中心下标

        for i in range(n):
            # 如果 i 在当前expand rightmost 的回文子串的范围内, 则利用之前的结果来加速计算
            if i <= rightmost_j:
                i_sym = 2 * j - i # i 关于 j 的对称点
                min_arm_len_i = min(rightmost_j - i, arm_len[i_sym]) # 以 i 为中心的回文子串的臂长至少为 min(rightmost_j - i, arm_len[i_sym])
                cur_arm_len_i = expand(i - min_arm_len_i, i + min_arm_len_i, s) # 尝试扩展以 i 为中心的回文子串
            # 否则，自己算
            else:
                cur_arm_len_i = expand(i, i, s)
            
            arm_len[i] = cur_arm_len_i # 更新以 s[i] 为中心的回文子串的臂长

            # 下面需要更新当前expand rightmost 的回文子串的中心和右边界
            if i + cur_arm_len_i > rightmost_j:
                j = i
                rightmost_j = i + cur_arm_len_i
            
            # 更新最长回文子串的开始和结束下标
            if 2 * cur_arm_len_i + 1 > end - start:
                start = i - cur_arm_len_i
                end = i + cur_arm_len_i

        # 需要剥离 s 中的 "#"
        return s[start:end+1].replace("#", "")
```