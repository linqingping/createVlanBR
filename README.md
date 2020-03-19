# createVlanBR
shell 脚本创建vlan网桥，实现网络划分
## 使用 
```
./createVlanBR.sh eno2 brvlan 10 100
```
eno2 网卡名
brvlan 网桥名前缀
10,100 vlan值
执行脚本后会创建相应vlan的网卡跟网桥
