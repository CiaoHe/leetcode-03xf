定义`s` 的真前缀为：不等于s的前缀；同理 真后缀为不等于`s`的后缀
定义`s`的 `border` :  s的真前缀&&真后缀
对于pattern p的每个前缀`p[:i`], 计算出这个前缀的最长 `border` 长度, 记录在 $\pi$ 数组中
- use $\pi$ we can quick calculate `p` occurrence in the `t`
- 一般国内会把 $\pi$  数组叫做 `next` 数组，关系是`next[i+1] \pi[i]+1`

# KMP template
实际上我们在构建  $\pi$  数组 的过程也是在做KMP的准备
推荐解读: [如何更好的理解和掌握KMP](https://www.zhihu.com/question/21923021/answer/37475572)
```python fold
def KMP(s:str, p:str) -> List[int]:
    m, n = len(s), len(p)
    
    def build_pi(p:str) -> List[int]:
	    n = len(p)
	    pi = [0] * n
	    max_length = 0
	    for i in range(1, n):
	        while max_length > 0 and p[max_length] != p[i]:
	            max_length = pi[max_length-1] # 如果当前字符不匹配，则将模式串的指针回退到上一个匹配位置
	        if p[max_length] == p[i]:
	            max_length += 1
	        pi[i] = max_length
	    return pi

    pi = build_pi(p)
    ans = []
    j = 0 # 模式串p的指针
    for i in range(m): # 文本串s的指针
        while j > 0 and s[i] != p[j]:
            j = pi[j-1] # 如果当前字符不匹配，则将模式串的指针回退到上一个匹配位置
        if s[i] == p[j]:
            j += 1 # 如果当前字符匹配，则将模式串的指针右移一位
        if j == n:
            ans.append(i-n+1) # 如果模式串的指针到达末尾，则找到了一个匹配位置
            j = pi[j-1] # 将模式串的指针回退到上一个匹配位置
    return ans

```

# [3008. 找出数组中的美丽下标 II](https://leetcode.cn/problems/find-beautiful-indices-in-the-given-array-ii/)
```python fold
class Solution:
    def beautifulIndices(self, s: str, a: str, b: str, k: int) -> List[int]:
        def KMP(s:str, p:str) -> List[int]:
            m, n = len(s), len(p)
            
            def build_pi(p:str) -> List[int]:
                n = len(p)
                pi = [0] * n
                max_length = 0
                for i in range(1, n):
                    while max_length > 0 and p[max_length] != p[i]:
                        max_length = pi[max_length-1] # 如果当前字符不匹配，则将模式串的指针回退到上一个匹配位置
                    if p[max_length] == p[i]:
                        max_length += 1
                    pi[i] = max_length
                return pi

            pi = build_pi(p)
            ans = []
            j = 0 # 模式串p的指针
            for i in range(m): # 文本串s的指针
                while j > 0 and s[i] != p[j]:
                    j = pi[j-1] # 如果当前字符不匹配，则将模式串的指针回退到上一个匹配位置
                if s[i] == p[j]:
                    j += 1 # 如果当前字符匹配，则将模式串的指针右移一位
                if j == n:
                    ans.append(i-n+1) # 如果模式串的指针到达末尾，则找到了一个匹配位置
                    j = pi[j-1] # 将模式串的指针回退到上一个匹配位置
            return ans

        pos_a = KMP(s, a)
        pos_b = KMP(s, b)
        
        ans = []
        for pa in pos_a:
            bi = bisect_left(pos_b, pa)
            if bi < len(pos_b) and pos_b[bi] - pa <= k or bi > 0 and pa - pos_b[bi-1] <= k:
                ans.append(pa)
        return ans
```