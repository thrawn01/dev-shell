package main

import (
	"os"
	"fmt"
	"syscall"
)

func main() {
	fd, err := os.OpenFile("/.k8-env", os.O_WRONLY|os.O_CREATE, os.ModePerm)
	if err != nil {
		panic(err)
	}
	// Simply writes the environment variables given to us by k8
	// into a file that users can source into their environments
	// during login (see 'profile')
	for _, pair := range os.Environ() {
		fmt.Printf("export %s\n", pair)
		fmt.Fprintf(fd, "export %s\n", pair)
	}
	fd.Close()

	// Start ssh
	err = syscall.Exec("/usr/sbin/sshd", []string{"/usr/sbin/sshd", "-De"}, os.Environ())
	if err != nil {
		panic(err.Error())
	}
}