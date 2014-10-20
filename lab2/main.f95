program main
    real, dimension(600) :: x
    real, dimension(2) :: start
    real, dimension(size(x), size(start)) :: y1, y2
    start = (/ 1.0, 0.0 /)
    x = (/ (0.05 * (I-1), I = 1, 600) /)
    y1 = euler(f, x, start)
    y2 = pceuler(f, x, start)
    open(unit=1, file="data.out")
    do i = 1, size(x)
        write (1, *) x(i), y1(i, 1), y2(i, 1)
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

    pure function f(x, y)
        real, intent(in) :: x
        real, dimension(:), intent(in) :: y
        real, dimension(size(y)) :: f
        f(1) = y(2)
        f(2) = -y(1)
    end function f

end program main
