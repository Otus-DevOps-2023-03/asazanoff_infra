#!/bin/bash
systemctl daemon-reload
systemctl enable reddit_full.service
systemctl start reddit_full
