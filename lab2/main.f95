program main
    real, dimension(20) :: x, y
    x = (/ (0.05 * (I-1), I = 1, 20) /)
    y = euler(f, x, 1.0)
    print *, x
    print *, y
    print *, exp(-x)

contains

    function euler (f, x, y0)
        real, dimension(:) :: x
        real, dimension(size(x)) :: y, euler
        real :: y0
        integer :: i
        y(1) = y0
        do i = 1, size(x) - 1
            y(i+1) = y(i) + f(x(i), y(i)) * (x(i+1) - x(i))
        end do
        euler = y
    end function euler

    real function f(x, y)
        f = -y
    end function f

end program main
