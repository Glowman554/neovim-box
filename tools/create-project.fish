#!/bin/env fish

function inputDialogString
    # check arguments
    if test (count $argv) -ne 2
        echo "Usage: inputDialog <title> <prompt>"
        return 1
    end

    set -l title $argv[1]
    set -l prompt $argv[2]

    set -l height 0
    set -l width 0
    set -l init ""


    dialog --stdout \
        --title "$title" \
        --inputbox "$prompt" $height $width "$init"
end

function inputDialogList
    # check arguments
    if test (count $argv) -lt 3
        echo "Usage: inputDialogList <title> <prompt> <item1> [<item2> ...]"
        return 1
    end

    set -l title $argv[1]
    set -l prompt $argv[2]
    set -l items $argv[3..-1]

    set -l height 0
    set -l width 0
    set -l listHeight 0


    dialog --stdout \
        --title "$title" \
        --menu "$prompt" $height $width $listHeight \
        $items
end

function inputDialogYesNo
    # check arguments
    if test (count $argv) -ne 2
        echo "Usage: inputDialogYesNo <title> <prompt>"
        return 1
    end

    set -l title $argv[1]
    set -l prompt $argv[2]

    set -l height 0
    set -l width 0

    dialog --stdout \
        --title "$title" \
        --yesno "$prompt" $height $width

    set -l exitStatus $status

    if test $exitStatus -eq 0
        echo "yes"
    else
        echo "no"
    end
end

# --- C project setup functions -- #

function writeMakefile 
    if test (count $argv) -ne 1
        echo "Usage: writeMakefile <projectName>"
        return 1
    end

echo "\
SRCS = \$(shell find -name '*.[c]')
OBJS = \$(addsuffix .o,\$(basename \$(SRCS)))


CFLAGS = -O2 -Wall -Iinclude -g
LDFLAGS =
PROGRAM ?= $argv[1]

\$(PROGRAM): \$(OBJS)
	\$(CC) \$(LDFLAGS) -o \$@ \$^

install: \$(PROGRAM)
	cp \$(PROGRAM) ~/go/bin/\$(PROGRAM)

%.o: %.c
	@echo CC \$^
	@\$(CC) \$(CFLAGS) -c -o \$@ \$^

clean:
	rm -f \$(OBJS) \$(PROGRAM) compile_flags.txt

compile_flags.txt:
	deno run -A https://raw.githubusercontent.com/Glowman554/MicroOS/refs/heads/master/compile_flags.ts \$(CFLAGS) > compile_flags.txt
" > Makefile
end

function setupCProject
    if test (count $argv) -ne 1
        echo "Usage: setupCProject <projectName>"
        return 1
    end

    mkdir "$argv[1]"
    cd "$argv[1]"


    writeMakefile "$argv[1]"
    mkdir include

    echo "#include <stdio.h>" > main.c
    echo "" >> main.c
    echo "int main() {" >> main.c
    echo "    printf(\"Hello, C Project!\\n\");" >> main.c
    echo "    return 0;" >> main.c
    echo "}" >> main.c
end


# --- C project setup functions -- #

# --- FireStorm project setup functions -- #

function setFireStormOutput
    if test (count $argv) -ne 1
        echo "Usage: setFireStormOutput <outputPath>"
        return 1
    end

    set -l output $argv[1]

    if not test -f fire.json
        echo "fire.json not found"
        return 1
    end

    jq --arg out "$argv[1]" \
       '.compiler.output = $out' fire.json > fire.json.tmp

    and mv fire.json.tmp fire.json
end

function setFireStormTarget
    if test (count $argv) -ne 1
        echo "Usage: setFireStormTarget <targetPlatform>"
        return 1
    end

    set -l target $argv[1]

    if not test -f fire.json
        echo "fire.json not found"
        return 1
    end
    
    jq --arg tgt "$argv[1]" \
       '.compiler.target = $tgt' fire.json > fire.json.tmp

    and mv fire.json.tmp fire.json
end


function setupFireStormProject
    if test (count $argv) -ne 1
        echo "Usage: setupFireStormProject <projectName>"
        return 1
    end

    set -l executable (inputDialogYesNo "Executable" "Is this project an executable?")
        mkdir "$argv[1]"
    cd "$argv[1]"

    if test $executable = "yes"
        fire init --name="$argv[1]" --executable
    else
        fire init --name="$argv[1]"
    end

   
    if test $executable = "yes"
        set -l targetPlatform (inputDialogList "Target Platform" "Select the target platform:" \
            "1" "x86_64-pc-win32-msvc" \
            "2" "x86_64-pc-linux-gnu" \
            "3" "aarch64-unknown-linux-gnu" \
            "4" "riscv64-unknown-linux-gnu" \
            "5" "bytecode" \
            "6" "bytecode_flc" \
            "7" "do not specify")
    
        # change output path if bytecode
        if test $targetPlatform = "5" -o $targetPlatform = "6"
            setFireStormOutput "main.flbb"
        end
    

        switch $targetPlatform
            case "1"
                setFireStormTarget "x86_64-pc-win32-msvc"
            case "2"
                setFireStormTarget "x86_64-pc-linux-gnu"
            case "3"
                setFireStormTarget "aarch64-unknown-linux-gnu"
            case "4"
                setFireStormTarget "riscv64-unknown-linux-gnu"
            case "5"
                setFireStormTarget "bytecode"
            case "6"
                setFireStormTarget "bytecode_flc"
            case "7"
                # do not specify target
            case '*'
                echo "Invalid target platform selected."
        end
    end

    echo "\$use <stdlib@1.0.8>" > main.fl
    echo "" >> main.fl
    echo "\$include <std.fl>" >> main.fl
    echo "" >> main.fl
    echo "function spark(int argc, str[] argv) -> int {" >> main.fl
    echo "    prints(\"Hello, FireStorm!\");" >> main.fl
    echo "    return 0;" >> main.fl
    echo "}" >> main.fl
end

# --- FireStorm project setup functions -- #

# --- Java (Maven) project setup functions -- #

function writePomXml
    if test (count $argv) -ne 4
        echo "Usage: writePomXml <projectName> <mainPackage> <mainClass> <groupId>"
        return 1
    end

echo "\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<project xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
         xmlns=\"http://maven.apache.org/POM/4.0.0\"
         xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd\">
    <modelVersion>4.0.0</modelVersion>

    <groupId>$argv[4]</groupId>
    <artifactId>$argv[1]</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.2.4</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer
                                        implementation=\"org.apache.maven.plugins.shade.resource.ManifestResourceTransformer\">
                                    <mainClass>$argv[2].$argv[3]</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <repositories>
        <repository>
            <id>toxicfox</id>
            <url>https://maven.toxicfox.de</url>
        </repository>
    </repositories>

    <dependencies>
    </dependencies>
</project>
" > pom.xml
end

function setupJavaMavenProject
    if test (count $argv) -ne 1
        echo "Usage: setupJavaMavenProject <projectName>"
        return 1
    end

    mkdir "$argv[1]"
    cd "$argv[1]"

    set -l groupId (inputDialogString "Group ID" "Enter the group ID:")
    set -l mainPackage (inputDialogString "Main Package" "Enter the main package name:")
    set -l mainClass (inputDialogString "Main Class" "Enter the main class name:")

    writePomXml "$argv[1]" "$mainPackage" "$mainClass" "$groupId"

    set -l mainPackagePath "src/main/java/$(echo $mainPackage | tr '.' '/')"

    mkdir -p "src/main/java/$mainPackagePath"
    mkdir -p "src/main/resources"

    echo "package $mainPackage;" > "src/main/java/$mainPackagePath/$mainClass.java"
    echo "" >> "src/main/java/$mainPackagePath/$mainClass.java"
    echo "public class $mainClass {" >> "src/main/java/$mainPackagePath/$mainClass.java"
    echo "    public static void main(String[] args) {" >> "src/main/java/$mainPackagePath/$mainClass.java"
    echo "        System.out.println(\"Hello, Java (Maven) Project!\");" >> "src/main/java/$mainPackagePath/$mainClass.java"
    echo "    }" >> "src/main/java/$mainPackagePath/$mainClass.java"
    echo "}" >> "src/main/java/$mainPackagePath/$mainClass.java"
end

# --- Java (Maven) project setup functions -- #

set projectName (inputDialogString "Project Name" "Enter the project name:")
set projectType (inputDialogList "Project Type" "Select the project type:" \
    "1" "C Project" \
    "2" "FireStorm Project" \
    "3" "Java (Maven) Project")

switch $projectType
    case "1"
        setupCProject "$projectName"
    case "2"
        setupFireStormProject "$projectName"
    case "3"
        setupJavaMavenProject "$projectName" 
    case '*'
        echo "Invalid project type selected."
end

