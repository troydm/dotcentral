#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>

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

    color("217","242");
    fputs(user,stdout);
    color("230","242");
    fputs(hostname,stdout);
    color("242","233");
    fputs("",stdout);
    color("223","233");
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
                dirfixed[j++] = '\xee';
                dirfixed[j++] = '\x82';
                dirfixed[j++] = '\xb1';
                dirfixed[j++] = '\x20';
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
                color("233","242");
                fputs("",stdout);
                color("151","242");
                fputs(&git[0],stdout);
                resetcolor();
                colorfg("242");
                fputs("",stdout);
            }
        }
        pclose(fp);
    }

    if(git_len == 0){
        resetcolor();
        colorfg("233");
        fputs("",stdout);
    }
    resetcolor();
    fputs("\n",stdout);

    return 0;
}
