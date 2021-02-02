@echo Swappind img files
@echo (C)2000 Belei Sergiy
@echo off
copy points2.img $$temp$$.bel>>nul
copy points21.img points2.img>>nul
copy $$temp$$.bel points21.img>>nul
del $$temp$$.bel>>nul