#!/usr/bin/env bash

echo "Looking for refurbished mac books..."
echo
echo https://www.apple.com/shop/refurbished/mac/macbook-pro
echo
curl https://www.apple.com/shop/refurbished/mac/macbook-pro | grep --color=always 'href="/shop/.*refurbished-.*-macbook-pro-apple-m1'
echo
echo
