package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func scan() string {
	in := bufio.NewScanner(os.Stdin)
	in.Scan()
	if err := in.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Ошибка ввода:", err)
	}
	return in.Text()
}

func polynom(coef []float64, x float64) float64 {
	var res float64 = 0
	for i := 0; i < len(coef); i++ {
		res += coef[i] * math.Pow(x, float64(i))
	}
	return res
}

type Task struct {
	coefficients []float64
	eps, a, b    float64
	solution     *float64
}

func (task *Task) getTask() {
	var str string
	fmt.Print("Введите коэффициенты полинома:")
	str = scan()
	var s = strings.Split(str, " ")
	var arr = make([]float64, 0, len(s))
	for i := (len(s) - 1); i >= 0; i-- {
		if num, err := strconv.ParseFloat(s[i], 8); err == nil {
			arr = append(arr, num)
		}
	}
	var degree int
	fmt.Print("Введите левую границу отрезка:")
	fmt.Scan(&task.a)
	fmt.Print("Введите правую границу отрезка:")
	fmt.Scan(&task.b)
	fmt.Print("Задайте точность, с которой надо найти решение(степень):")
	fmt.Scan(&degree)
	task.coefficients = arr
	task.eps = math.Pow10(-degree)
	task.solution = nil
}

func (task *Task) theBisectionMethod() {
	valA := polynom(task.coefficients, task.a)
	valB := polynom(task.coefficients, task.b)
	var solution float64
	if valA*valB > 0 {
		return
	}
	if valA == 0 {
		solution = task.a
		return
	} else if valB == 0 {
		solution = task.b
	} else {
		var c, valC float64
		a := task.a
		b := task.b
		for math.Abs(a-b) > task.eps {
			c = (a + b) / 2
			valC = polynom(task.coefficients, c)
			if valC == 0 {
				break
			}
			if valA*valC < 0 {
				b = c
			} else {
				a = c
				valA = valC
			}
		}
		solution = (a + b) / 2
	}
	task.solution = &solution
}

func main() {
	task := Task{}
	task.getTask()
	task.theBisectionMethod()
	if task.solution != nil {
		fmt.Println("Корень полинома на указанном промежутке:", *task.solution)
	} else {
		fmt.Println("Корни на указанном промежутке отсутсвуют.")
	}

}
