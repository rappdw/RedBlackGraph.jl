# RedBlackGraph.jl - A DAG of Multiple, Interleaved Binary Trees

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rappdw.github.io/RedBlackGraph.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rappdw.github.io/RedBlackGraph.jl/dev)
[![Build Status](https://travis-ci.com/rappdw/RedBlackGraph.jl.svg?branch=main)](https://travis-ci.com/rappdw/RedBlackGraph.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/rappdw/RedBlackGraph.jl?svg=true)](https://ci.appveyor.com/project/rappdw/RedBlackGraph-jl)
[![Coverage](https://codecov.io/gh/rappdw/RedBlackGraph.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/rappdw/RedBlackGraph.jl)
[![Coverage](https://coveralls.io/repos/github/rappdw/RedBlackGraph.jl/badge.svg?branch=main)](https://coveralls.io/github/rappdw/RedBlackGraph.jl?branch=main)

## Introduction
Red-Black Graphs are a specific type of graph, a directed acyclic graph of interleaved binary trees. This data 
structure resulted from exploration of efficient representations for family history. This package presents and 
implements the underlying linear algebra as well as discusses some interesting applications.

This Julia module is a port/rewrite of the [python implementation](https://github.com/rappdw/redblackgraph)
