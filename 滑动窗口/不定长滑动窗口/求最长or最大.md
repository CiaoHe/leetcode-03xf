#  [3. 无重复数字的最长子串](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)
方法一：用cnter来维护出现的char的次数，一旦发现当前右边界的char出现的次数>1, 立刻收缩左边届
```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        n = len(s)
        l = 0
        cnt = Counter()
        ans = 1
        for r,x in enumerate(s):
            cnt[x]+=1
            # 不断收缩l
            while cnt[x]>1:
                cnt[s[l]] -= 1
                l += 1
            ans = max(r-l+1, ans)
        return ans
```
方法二：用hash来维护每个char出现的位置，一旦发现当前右边界出现在hash中，立刻收缩左边届到`max(l, d[char]+1)`
```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        n = len(s)
        d = dict()
        res = 0
        l = 0 # left bound
        for i,c in enumerate(s):
            if c in d:
                l = max(l,d[c]+1)
            d[c] = i
            res = max(i-l+1, res)
        return res
```
# [3297. 统计重新排列后包含另一个字符串的子字符串数目 I](https://leetcode.cn/problems/count-substrings-that-can-be-rearranged-to-contain-a-string-i/)
参考模版题目[[3. 无重复数字的最长子串](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)](#[3.%20无重复数字的最长子串](https%20//leetcode.cn/problems/longest-substring-without-repeating-characters/))
- 用right向前滑动
- 用left来收缩左边界，同时left的位置也标志着以 `right` 为右边界合法的子串数目
```python
class Solution:
    def validSubstringCount(self, word1: str, word2: str) -> int:
        m,n = len(word1), len(word2)
        if m < n:
            return 0
        cnt1 = Counter()
        cnt2 = Counter(word2)
        
        res = 0
        left = 0
        for right, c in enumerate(word1):
            cnt1[c] += 1
            while cnt1 >= cnt2:
                cnt1[word1[left]] -= 1
                left += 1
            res += left
        return res
```