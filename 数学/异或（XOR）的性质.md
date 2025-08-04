异或（⊕）运算有以下重要性质：
1. ​**​交换律​**​：a⊕b=b⊕a
2. ​**​结合律​**​：(a⊕b)⊕c=a⊕(b⊕c)
3. ​**​自反性​**​：a⊕a=0
4. ​**​与 0 的异或​**​：a⊕0=a
5. ​**​可逆性​**​：如果 a⊕b=c，那么 a=b⊕c 和 b=a⊕c

# [2683. 相邻值的按位异或](https://leetcode.cn/problems/neighboring-bitwise-xor/)
假设：
- original=[a0​,a1​,a2​,…,an−1​]
- derived=[d0​,d1​,d2​,…,dn−1​]

根据定义：
$$ d_{0} = a_{0} \oplus a_{1} $$
$$ d_{1} = a_{1} \oplus a_{2} $$
$$ \vdots $$
$$ d_{n-2} = a_{n-2} \oplus a_{n-1} $$
$$ d_{n-1} = a_{n-1} \oplus a_{0} $$
$$ a_{1} = a_{0} \oplus d_{0} $$

$$ a_{2} = a_{1} \oplus d_{1} = a_{0} \oplus d_{0} \oplus d_{1} $$

$$ a_{3} = a_{2} \oplus d_{2} = a_{0} \oplus d_{0} \oplus d_{1} \oplus d_{2} $$

$$ \vdots $$

$$ a_{n-1} = a_{0} \oplus d_{0} \oplus d_{1} \oplus \cdots \oplus d_{n-2} $$
最后需要检查$a_0$ xor $a_{n-1}$ == $d_{n-1}$
那么我们把$a_{n-1}$ 展开可以得到  (a0​⊕d0​⊕d1​⊕⋯⊕dn−2​)⊕a0​=dn−1​
根据xor的性质可以消除掉$a_0$ (交换律+自反)
同时可以两边xor上 $d_{n-1}$, 最后需要判别 d0​⊕d1​⊕⋯⊕dn−1​=0

```python
class Solution:
    def doesValidArrayExist(self, derived: List[int]) -> bool:
        return reduce(xor, derived) == 0
```