verhoeff
=====

[![Build Status](https://travis-ci.org/mururu/verhoeff.svg?branch=master)](https://travis-ci.org/mururu/verhoeff)
[![hex.pm version](https://img.shields.io/hexpm/v/verhoeff.svg)](https://hex.pm/packages/verhoeff)

An Erlang implementaion of the Verhoeff algorithm created by Jacobus Verhoeff.  
The Verhoeff algoritm is a check digit algorithm which can detects all single-digit errors and all adjacent transposition errors.  
More details: [Verhoeff algorithm - Wikipedia](https://en.wikipedia.org/wiki/Verhoeff_algorithm)

## Usage

##### `verhoeff:checksum/1`

```
1> verhoeff:checksum(236).
3
2> verhoeff:checksum("236").
3
3> verhoeff:checksum(<<"236">>).
3
```

##### `verhoeff:encode/1`

```
1> verhoeff:encode(236).
2363
2> verhoeff:encode("236").
"2363"
3> verhoeff:encode(<<"236">>).
<<"2363">>
```

##### `verhoeff:is_valid/1`

```
1> verhoeff:is_valid(2363).
true
2> verhoeff:is_valid("2363").
true
3> verhoeff:is_valid(<<"2363">>).
true
4> verhoeff:is_valid(5723).
false
```
