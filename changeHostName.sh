#!/bin/bash

read -p "Enter line : " ten
hostnamectl set-hostname $ten
hostnamectl
