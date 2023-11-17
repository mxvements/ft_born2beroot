<div align="center">
    <img src="https://img.shields.io/badge/status-wip-success?color=00ABAD&style=flat-square" />
    <img src="https://img.shields.io/badge/started-17%20%2F%2011%20%2F%202023-success?color=00ABAD&style=flat-square" />
    <img src="https://img.shields.io/badge/score-1--%20%2F%20100-success?color=00ABAD&style=flat-square" />
    <img src="https://img.shields.io/github/languages/top/mxvements/ft_get_next_line?color=00ABAD&style=flat-square" />
    <img src="https://img.shields.io/github/last-commit/mxvements/ft_get_next_line?color=00ABAD&style=flat-square" />
    <br>
    <a href='https://www.linkedin.com/in/luciami' target="_blank"><img alt='Linkedin' src='https://img.shields.io/badge/LinkedIn-100000?style=flat-square&logo=Linkedin&logoColor=white&labelColor=1323233&color=323233'/></a>
    <a href='https://profile.intra.42.fr/users/luciama2' target="_blank"><img alt='42' src='https://img.shields.io/badge/Madrid-100000?style=flat-square&logo=42&logoColor=white&labelColor=323233&color=323233'/></a>
    <br>
</div>

# born2beroot

This project aims to introduce you to the wonderful world of virtualization. We will crete a first machine in VirtualBox (or UTM if you can't use VirtualBox) under specific instructions. Then, at the end of this project we will be able to set up your own operating system while implementing strict rules.

Rules:

* The use of VirtualBox is mandatory.
* You only have to turn in a signature.txt file at the root of your repository. You must paste in it the signature of your machine's virtual disk. Go to Submission and peer-evaluation for more information.

## Mandatory part

This project consists of having you set up your first server by following specific rules. You must choose as an operating system either the latest stable version of Debian (no testing/unstable), or the latest stable version of Rocky. Debian is highly recommended if you are new to system administration.

* You must create at least 2 encrypted partitions using LVM.
* A SSH service will be running on port 4242 only. For security reasons, it must no be possible to connect using SSH as root.
* You have to configure your operating system with the UFW (or firewalld for Rocky) firewall and thus leave only port 4242 open.
* The `hostname` of your virtual machine must be your login ending with 42. You will have to modify the hostname during the eval.
* You have to implement a strong password policy.
    * Passw has to expire every 30 days.
    * Min. number of days allowed before the modification of a passw will be set to 2.
    * The user has to receive a warning message 7 days before their passw expires.
    * The passw must be at least 10 chars long. It must contain an uppercase letter, a lowercase letter, and a number. Also, it must not contain more than 3 consecutive identical numbers.
    * It mustn't include the name of the user.
    * The following rule doesn't apply to the root passw: it must have at leas 7 chars that are not part of the former passw.
    * of course, the root passw hass to comply with this policy
* You have to install and configure `sudo` following strict rules.
    * Auth. using sudo has to be limited to 3 attempts in the event of an incorrect passw
    * A custom message of your choice has to be displayed if an error due to a wrong passw occurs when using `sudo`.
    * each action using sudo has to be archived, both inputs and outputs. The log file has to be saved in `/var/log/sudo/folder`.
    * the YYT mode has to enabled for security reasons.
    * For security reasons too, the paths that can be used nu `sudo` must be restricted, e.g. `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`.
* In addition to the root user, a user with your login as username has to be present.
* This user has to belong to the `user42` and `sudo` groups.
* Finally, you have to create a simplle script called `monitoring.sh`, it must be opened in `bash`. Your script must always be able to display the following information:
    * The architecture of your operating system and its kernel version.
    * The number of physical processors.
    * The number of virtual processors.
    * The current available RAM on your server and its utilization rate as a percentage.
    * The current available memory on your server and its utilization rate as a percentage.
    * The current utilization rate of your processors as a percentage.
    * The date and time of the last reboot.
    * Whether LVM is active or not.
    * The number of active connections.
    * The number of users using the server.
    * The IPv4 address of your server and its MAC (Media Access Control) address.
    * The number of commands executed with the sudo program.

At server startup, the script will display info on all terminals every 10 minutes (take a look at `wall`), the banner is optional. No error must be visible.

## Bonus part

* Set up partitions correctly so you get a structure similar to the one below (img provided on the subject).
* Set up a functional WordPress website with the following services: lighttpd, MariaDB, and PHP.
* Set up a service of your choice that you think is useful (NGINX / Apache2 excluded!). During the defense, you will have to justify your choice.

# How to use


# Other

## Norminete
At 42 School, it is expected that almost every project is written in accordance with the Norm, which is the coding standard of the school.

<a href="https://github.com/42School/norminette">
<a>Norminette's repository</a>

```
- No for, do...while, switch, case, goto, ternary operators and variable-length arrays are allowed
- Each function must be a maximum of 25 lines, not counting the function's curly brackets
- Each line must be at most 80 columns wide, comments included
- A function can take 4 named parameters maximum
- No assigns and declarations in the same line (unless static or const)
- You can't declare more than 5 variables per function
- ...
```
## Aknowledgments

# License
[MIT License](https://github.com/mxvements/ft_license/blob/main/LICENSE.txt)
