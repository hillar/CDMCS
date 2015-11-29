# BRO cluster

see https://www.bro.org/sphinx/cluster/index.html

https://www.bro.org/sphinx-git/scripts/base/frameworks/cluster/main.bro.html#namespace-Cluster

![main parts of cluster](https://www.bro.org/sphinx/_images/deployment.png)

## Worker

 * sniffs traffic and does analysis 

## Proxy

 * manages synchronized state

## Manager

 * waits for workers
 * stores logs
 * dedups notices
