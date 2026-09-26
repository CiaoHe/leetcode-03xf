# [3474. 字典序最小的生成字符串](https://leetcode.cn/problems/lexicographically-smallest-generated-string/)
给你两个字符串，`str1` 和 `str2`，其长度分别为 `n` 和 `m` 。

如果一个长度为 `n + m - 1` 的字符串 `word` 的每个下标 `0 <= i <= n - 1` 都满足以下条件，则称其由 `str1` 和 `str2` **生成**：

- 如果 `str1[i] == 'T'`，则长度为 `m` 的 **子字符串**（从下标 `i` 开始）与 `str2` 相等，即 `word[i..(i + m - 1)] == str2`。
- 如果 `str1[i] == 'F'`，则长度为 `m` 的 **子字符串**（从下标 `i` 开始）与 `str2` 不相等，即 `word[i..(i + m - 1)] != str2`。

返回可以由 `str1` 和 `str2` **生成** 的 **字典序最小** 的字符串。如果不存在满足条件的字符串，返回空字符串 `""`。

如果字符串 `a` 在第一个不同字符的位置上比字符串 `b` 的对应字符在字母表中更靠前，则称字符串 `a` 的 **字典序 小于** 字符串 `b`。  
如果前 `min(a.length, b.length)` 个字符都相同，则较短的字符串字典序更小。

**子字符串** 是字符串中的一个连续、**非空** 的字符序列。


```python
class Solution:
    def generateString(self, str1: str, str2: str) -> str:
        n,m = len(str1), len(str2)
        s, t = str1, str2

        ans = ['?'] * (n+m-1)

        # 先处理T的情况
        for i,x in enumerate(s):
            if x == 'T':
                # 子串[i:i+m-1]等于t
                for j,c in enumerate(t):
                    v = ans[i+j]
                    if v!='?' and v!=c:
                        return ""
                    ans[i+j] = c
        
        old_ans = ans
        ans = ['a' if c == '?' else c for c in ans]

        # 再处理F
        for i,x in enumerate(s):
            if x != 'F':
                continue
            # 子串[i:i+m-1]必然不等于t
            if ''.join(ans[i:i+m]) != t:
                continue
            # 找到最后一个待定的位置(?)
            for j in range(i+m-1, i-1, -1):
                if old_ans[j] == '?':
                    ans[j] = 'b'
                    break
            else:
                return ""
        
        return ''.join(ans)
```

# [3720. 大于目标字符串的最小字典序排列](https://leetcode.cn/problems/lexicographically-smallest-permutation-greater-than-target/)
给你两个长度均为 `n` 且仅由小写英文字母组成的字符串 `s` 和 `target`

返回 `s` 的 **字典序最小的排列**，要求该排列 **严格** 大于 `target`。如果 `s` 不存在任何字典序严格大于 `target` 的排列，则返回一个空字符串。

如果两个长度相同的字符串 `a` 和 `b` 在它们首次出现不同字符的位置上，字符串 `a` 对应的字母在字母表中出现在 `b` 对应字母的 **后面** ，则字符串 `a` **字典序严格大于** 字符串 `b`。

**排列** 是字符串中所有字符的一种重新排列。


设最终答案是 `ans`，因为要求：
```
ans > target
```
那么一定存在一个**第一个不同的位置** `i`：
```
ans[0:i] == target[0:i]
ans[i] > target[i]
```
而 `i` 后面放什么已经不影响 `ans > target` 了。

为了让 `ans` 尽可能小，我们希望：
1. 第一个不同的位置 `i` **尽可能靠右**
2. 在这个位置，选择 **最小的、但大于 `target[i]` 的字符**
3. 后面的所有字符直接 **从小到大排列**

所以你说的：

> 尽可能贴着 target left -> right，如果能 exact match 就填 exact char

完全正确。

真正的问题只有一个：

> 如果一直 exact match，到了后面发现走不通怎么办？

答案就是：**回退到前面的某个位置，把它稍微变大。**

```python
class Solution:
    def lexGreaterPermutation(self, s: str, target: str) -> str:
        # 希望s的某个最小排序严格大于b
        n = len(s)
        cnter = Counter(s)
        ans = []

        def build_suffix():
            res = []
            for c in sorted(cnter.keys()):
                res.extend([c] * cnter[c])
            return res
        
        # 先尝试前缀匹配
        for i,ch in enumerate(target):
            if cnter[ch] > 0:
                ans.append(ch)
                cnter[ch] -= 1
                continue
                
            # 如果当前字符不够了, 那么就尝试找一个比ch大的字符
            for y in range(ord(ch)-ord('a')+1, 26):
                c = chr(y + ord('a'))
                if cnter[c] > 0:
                    ans.append(c)
                    cnter[c] -= 1
                    # 构建后缀
                    return ''.join(ans) + ''.join(build_suffix())
            # 当前位没办法变大，只能回退
            break

        for j in range(len(ans)-1, -1, -1):
            # 撤销
            ch = ans[j]
            cnter[ch] += 1
            for y in range(ord(ch)-ord('a')+1, 26):
                c = chr(y + ord('a'))
                if cnter[c] > 0:
                    ans[j] = c
                    cnter[c] -= 1
                    return ''.join(ans[:j+1]) + ''.join(build_suffix())
        
        return ""
```

# [3734. 大于目标字符串的最小字典序回文排列](https://leetcode.cn/problems/lexicographically-smallest-palindromic-permutation-greater-than-target/)
给你两个长度均为 `n` 的字符串 `s` 和目标字符串 `target`，它们都由小写英文字母组成。

返回 **字典序 最小的字符串** ，该字符串 **既** 是 `s` 的一个 **回文 排列** ，**又**是字典序 **严格** 大于 `target` 的。如果不存在这样的排列，则返回一个空字符串。

如果字符串 `a` 和字符串 `b` 长度相同，在它们首次出现不同的位置上，字符串 `a` 处的字母在字母表中的顺序晚于字符串 `b` 处的对应字母，则字符串 `a` 在 **字典序上严格大于** 字符串 `b`。

**排列** 是指对字符串中所有字符的重新排列。

如果一个字符串从前向后读和从后向前读都一样，则该字符串是 **回文** 的。

[[3720. 大于目标字符串的最小字典序排列](https://leetcode.cn/problems/lexicographically-smallest-permutation-greater-than-target/)](#[3720.%20大于目标字符串的最小字典序排列](https%20//leetcode.cn/problems/lexicographically-smallest-permutation-greater-than-target/)) 联动

- `left = Counter(s)`：表示**剩余可用字符资源**；左半边放一个字符 `c`，右半边必须镜像一个，所以 `left[c] -= 2`。
- 先处理奇数频次字符：回文最多只能有一个奇数字符，把它单独拿出来作为 `mid_c`。
- 核心目标：找**字典序最小且 > target** 的回文串，因此要让答案和 `target` 的前缀**尽量相同**，也就是“尽可能晚地第一次变大”。
- 先假设答案左半边完全等于 `target[:n//2]`，对应字符资源全部 `-2`；如果资源合法，就直接镜像，检查完整回文是否已经 `> target`。
	- 如果不行，从左半边**右往左回退**；`left[b] += 2` 表示撤销当前位置原本“照抄 target[i]”的假设。
- 只有当 `[0, i-1]` 仍能和 `target` 完全一致时，才尝试把 `target[i]` 换成一个**更大的可用字符**。
- 在位置 `i` 第一次变大后，已经保证答案 `> target`，所以后面的左半部分全部用剩余字符按**从小到大**填，保证答案最小。
- 最后把左半边镜像到右边，中间插入 `mid_c`。

```python
class Solution:
    def lexPalindromicPermutation(self, s: str, target: str) -> str:
        n = len(s)
        left = Counter(s) # 剩下的可以用的资源
        def valid():
            return all(c>=0 for c in left.values())
        
        mid_c = ''
        for c, freq in left.items():
            if freq % 2 == 0:
                continue
            if mid_c:
                return ''
            mid_c = c
            left[c] -= 1
        
        # 我们先尝试构造一个回文串 ans，让 ans 的左半边和 target 的左半边完全一样
        # 暂时不考虑中间mid_c
        for i,b in enumerate(target[:n//2]):
            left[b] -= 2
        
        if valid():
            # 特殊情况，直接left翻到right, 看能否比target大
            left_s = target[:n//2]
            right_s = left_s[::-1]
            if mid_c + right_s > target[n//2:]:
                return left_s + mid_c + right_s
        
        # 核心思想：尽可能晚的第一次变大
        for i in range(n//2-1, -1, -1):
            b = target[i]
            left[b] += 2 # 撤销消耗
            if not valid(): # [0,i-1]无法做到完全一样
                continue
        
            # 开始回退，尝试把target[i]换成比它大的字母
            for j in range(ord(b)-ord('a')+1, 26):
                c = chr(ord('a') + j)
                if left[c] == 0:
                    continue

                # 先把c放在target[i]的位置上
                left[c] -= 2
                ans = list(target[:i+1])
                ans[i] = c

                # 中间随便填写
                for ch in range(26):
                    ch = chr(ord('a') + ch)
                    ans.extend([ch] * (left[ch] // 2))
                
                # mirror
                right_s = ans[::-1]
                ans.append(mid_c)
                ans.extend(right_s)
                return ''.join(ans)
        
        return ''
```