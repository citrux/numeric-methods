program mathieu
    !  параметры уравнения Матьё
    real :: a, q
    ! сетка
    real, dimension(:), allocatable :: x
    ! начальные условия
    real, dimension(2), parameter :: start = (/ 1.0, 0.0 /)
    ! решения
    real, dimension(:,:), allocatable :: y1, y2, y3
    ! переменная для аргументов
    character*10 :: arg

    if (iargc()<4) then
        print *, "Программа для численного решения уравнения Матьё"
        call getarg(0, arg)
        print *, "Пример использования: ", trim(arg), " a q step n_steps"
        return
    end if

    call getarg(1, arg)
    read (arg,*) a

    call getarg(2, arg)
    read (arg,*) q

    call getarg(3, arg)
    read (arg,*) step

    call getarg(4, arg)
    read (arg,*) n_steps

    allocate(x(n_steps))
    allocate(y1(n_steps, 2))
    allocate(y2(n_steps, 2))
    allocate(y3(n_steps, 2))

    x = (/ (step * (I-1), I = 1, size(x)) /)
    y1 = euler(f, x, start)
    y2 = pceuler(f, x, start)
    y3 = rk4(f, x, start)
    open(unit=1, file="data.out")
    write (1, *) " x euler pceuler rk4"
    do i = 1, size(x)
        write (1, *) x(i), y1(i, 1), y2(i, 1), y3(i, 1)
    end do
    close(1)

contains

    function euler (f, x, y0)
        real, dimension(:) :: x
        real, dimension(:) :: y0
        real, dimension(size(x), size(y0)) :: y, euler
        integer :: i

        interface
            pure function f(x, y)
                real, intent(in) :: x
                real, dimension(:), intent(in) :: y
                real, dimension(size(y)) ::  f
            end function f
        end interface

        y(1,:) = y0
        do i = 1, size(x) - 1
            y(i+1,:) = y(i,:) + f(x(i), y(i,:)) * (x(i+1) - x(i))
        end do
        euler = y
    end function euler

    function pceuler (f, x, y0)
        real, dimension(:) :: x
        real, dimension(:) :: y0
        real, dimension(size(y0)) :: z
        real, dimension(size(x), size(y0)) :: y, pceuler
        integer :: i

        interface
            pure function f(x, y)
                real, intent(in) :: x
                real, dimension(:), intent(in) :: y
                real, dimension(size(y)) ::  f
            end function f
        end interface

        y(1,:) = y0
        do i = 1, size(x) - 1
            z = y(i,:) + f(x(i), y(i,:)) * (x(i+1) - x(i))
            y(i+1,:) = y(i,:) + (f(x(i), y(i,:)) + f(x(i), z)) * (x(i+1) - x(i))/2
        end do
        pceuler = y
    end function pceuler

    function rk4 (f, x, y0)
        real, dimension(:) :: x
        real, dimension(:) :: y0
        real, dimension(size(y0)) :: k1, k2, k3, k4
        real, dimension(size(x), size(y0)) :: y, rk4
        integer :: i
        real :: h

        interface
            pure function f(x, y)
                real, intent(in) :: x
                real, dimension(:), intent(in) :: y
                real, dimension(size(y)) ::  f
            end function f
        end interface

        y(1,:) = y0
        do i = 1, size(x) - 1
            h = x(i+1) - x(i)
            k1 = h * f(x(i), y(i,:))
            k2 = h * f(x(i) + h/2, y(i,:) + k1/2)
            k3 = h * f(x(i) + h/2, y(i,:) + k2/2)
            k4 = h * f(x(i+1), y(i,:)+k3)
            y(i+1,:) = y(i,:) + (k1 + 2 * k2 + 2 * k3 + k4) / 6
        end do
        rk4 = y
    end function rk4

    pure function f(x, y)
        real, intent(in) :: x
        real, dimension(:), intent(in) :: y
        real, dimension(size(y)) :: f
        f(1) = y(2)
        f(2) = -(a - 2 * q * cos(2 * x)) * y(1)
    end function f

end program mathieu
