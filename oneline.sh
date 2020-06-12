history | grep -P '^\s*[0-9]+\s*sudo \S+' | grep -oP 'sudo .*' | uniq -c

# 1- Explanation for each part of the one-liner command:

#history: its default behavior is to display the list of commands called from the terminal, one command (with arguments) on each line with a line number

# | (pipe symbol): forwards the output of the previous command (on the left side of the pipe) as input to the next command (on the right side of the pipe)

#grep: displays lines from the input that match a pattern. The command grep offers many options, two of which I have used here:

## -P : uses Perl-compatible regex, which is more familiar to me. In an early version of my solution, it seemed even necessary, 
##since I was using a lookahead, an functionality not available in bash (more on this further below).

## -o : displays only matched parts of a line. This option is not used in the first part, since it would remove whatever comes after the next word after sudo,
##In the second part, it is needed so that only the line starting with the keyword "sudo" is displayed and counted

#uniq: displays the unique lines of the input. Has many options, of which we used the following one:

## -c : displays the count of each unique line at the beginning of the line.

#Regular expressions:

# '^\s*[0-9]+\s+sudo \S+' : a string that starts with 0 or multiple spaces followed by at least one digit followed by at least one space followed by the keyword sudo
#followed by a space then one or several characters that are not white space. This matches a line from the history where sudo is the first command.

##Following are the explanations for each special keyword:

## ^ : starts with.
## \s : white space
## * : previous character or pattern repeated 0 or multiple times
## [0-9] : any digit between 0 and 9
## + : previous character or pattern repeated 1 or multiple times
## \S : any character but a white space

# 'sudo .*' : the word sudo followed by a space, then any character repeated multiple times. Since the first regex did most of the filtering, the second regex, with
#the help of the grep option -o has the simple task of returning the line starting with sudo

#An early version of my solution looked like this: history | grep -P '^\s*[0-9]+\s*sudo \S+' | grep -oP '(?<=[0-9]\s{2})sudo .*' | uniq -c
#The regular expression '(?<=[0-9]\s{2})sudo .*' uses a lookahead (?<=[0-9]\s{2}) to check if the word sudo is preceded by a digit followed by two spaces, without 
#displaying this pattern (i.e. the line would still be displayed starting from sudo). This, once again, is unncessary, since the first regex already did that job.

# 2- Testing:

#To ensure that the one-line command does its job as intended, I made a list of test cases, or rather potential failure cases:

## sudo is not the first word in the command: the keyword sudo is intended to execute another command with root privileges, and in its correct syntax should therefore
##appear first.

### Test case 1: let's create a file named "sudo" and give it the timestamp January 4, 1985 at 16:00, and to make sure sudo is not the last word either, we add the option
## -f at the end. The command would be:
### touch -t 8501041600 sudo -f
### when we run our one-liner, this command does not appear: SUCCESS!

## sudo is executed alone. This would normally result in the display of help instructions. But since sudo, according to the assignment, should be used with another command
##this case should not appear in the list of results.

### Test case 2: use sudo alone
### sudo
### when we run our one-liner, this command does not appear: SUCCESS!

### Test case 3: use sudo alone but add one space afterwards
### sudo 
### when we run our one-liner, this command does not appear: SUCCESS!

### Test case 4: use sudo with more than one space afterwards
### sudo   
### when we run our one-liner, this command does not appear: SUCCESS!

## sudo is part of a word, for example "sudoku".

### Test case 5: we type an absurd command
### sudoku -ma 
### when we run our one-liner, this command does not appear: SUCCESS!

## Any other uses of sudo, with another command or option, will appear in the final list returned by the one-liner.