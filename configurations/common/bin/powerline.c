#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>

// color config
const char* user_color = "217";
const char* hostname_color = "230";
const char* user_hostname_bg_color = "242";
const char* dir_color = "223";
const char* dir_bg_color = "233";
const char* dir_bg_alt_color = "239";
const char* git_color = "151";
const char* git_bg_color = "242";

// color utility functions
void color(const char* fg, const char* bg){
    fputs("\x1b[38;5;",stdout);
    fputs(fg,stdout);
    fputs(";48;5;",stdout);
    fputs(bg,stdout);
    fputs("m",stdout);
}

void colorfg(const char* fg){
    fputs("\x1b[38;5;",stdout);
    fputs(fg,stdout);
    fputs("m",stdout);
}

void resetcolor(){
    fputs("\x1b[0m",stdout);
}

int main(int argc, char* argv[]){
    struct passwd* pw;
    int dir_alt = 0;
    char* user = "";
    char* homedir = "";
    char hostname[256];
    char dir[1024];
    char dirfixed[1024];
    char git[1024];
    git[0] = '\0';
    hostname[0] = '@';
    pw = getpwuid (geteuid());
    if(pw){
        user = pw->pw_name;
        homedir = pw->pw_dir;
    }
    gethostname(&hostname[1],254);
    // strip '.local' suffix
    char *i = index(hostname, '.');
    if (i != NULL) {
        *i = '\0';
    }
    // print user@hostname
    color(user_color,user_hostname_bg_color);
    fputs(user,stdout);
    color(hostname_color,user_hostname_bg_color);
    fputs(hostname,stdout);
    color(user_hostname_bg_color,dir_bg_color);
    fputs("",stdout);
    // print current dir
    color(dir_color,dir_bg_color);
    if(getcwd(&dir[0], 1024)){
        int homedir_size = strlen(homedir);
        int j = 1;
        int i = 1;
        if(homedir > 0 && strncmp(homedir, &dir[0], homedir_size) == 0){
            dirfixed[0] = '~';
            i = homedir_size;
        }else{
            dirfixed[0] = dir[0];
        }
        while(dir[i] != '\0'){
            if(dir[i] == '/'){
                dirfixed[j++] = '\0';
                fputs(&dirfixed[0],stdout);
                if (dir_alt == 0) {
                    color(dir_bg_color,dir_bg_alt_color);
                    fputs("",stdout);
                    color(dir_color,dir_bg_alt_color);
                    dir_alt = 1;
                } else {
                    color(dir_bg_alt_color,dir_bg_color);
                    fputs("",stdout);
                    color(dir_color,dir_bg_color);
                    dir_alt = 0;
                }
                j = 0;
            }else
                dirfixed[j++] = dir[i];
            i++;
        }
        dirfixed[j++] = '\0';
        fputs(&dirfixed[0],stdout);
    }
    // determine git branch
    int git_len = 0;
    FILE* fp = popen("git rev-parse --abbrev-ref HEAD", "r");
    if (fp) {
        if(fgets(git, 1023, fp)){
            git_len = strlen(&git[0]);
            if(git_len > 0){
                git[git_len-1] = '\0';
                if (dir_alt == 0) {
                    color(dir_bg_color,git_bg_color);
                } else {
                    color(dir_bg_alt_color,git_bg_color);
                }
                // print git branch
                fputs("",stdout);
                color(git_color,git_bg_color);
                fputs("",stdout);
                fputs(&git[0],stdout);
                resetcolor();
                colorfg(git_bg_color);
                fputs("",stdout);
            }
        }
        pclose(fp);
    }

    // print ending arrow
    if(git_len == 0){
        resetcolor();
        if (dir_alt == 0) {
            colorfg(dir_bg_color);
        } else {
            colorfg(dir_bg_alt_color);
        }
        fputs("",stdout);
    }
    resetcolor();
    fputs("\n",stdout);

    return 0;
}

