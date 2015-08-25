#!/bin/env bash
declare -A urlencode
for i in {32..47};do
  echo -n "$i:"
  printf "%x" "$i"
  echo -n ":"
  printf \\x"$(printf "%x\n" "$i")\n"
  urlencoded[$(printf "%x" "$i")]=$(printf \\x"$(printf "%x\n" "$i")\n")
done
for i in {58..64};do
  echo -n "$i:"
  printf "%x" "$i"
  echo -n ":"
  printf \\x"$(printf "%x\n" "$i")\n"
  urlencoded[$(printf "%x" "$i")]=$(printf \\x"$(printf "%x\n" "$i")\n")
done
for i in {91..96};do
  echo -n "$i:"
  printf "%x" "$i"
  echo -n ":"
  printf \\x"$(printf "%x\n" "$i")\n"
  urlencoded[$(printf "%x" "$i")]=$(printf \\x"$(printf "%x\n" "$i")\n")
done
for i in {123..126};do
  echo -n "$i:"
  printf "%x" "$i"
  echo -n ":"
  printf \\x"$(printf "%x\n" "$i")\n"
  urlencoded[$(printf "%x" "$i")]=$(printf \\x"$(printf "%x\n" "$i")\n")
done
for i in ${!urlencoded[@]};do echo "[${i}:${urlencoded[${i}]}]";done

echo ${urlencoded[23]}
echo ${!urlencoded[@]}



