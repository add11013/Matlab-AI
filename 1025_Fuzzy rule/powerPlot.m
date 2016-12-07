plot(z',power_mf');
axis([-inf inf 0 1.2]);
xlabel('Z'); ylabel('Membership Grades');
text(350, 1.1, 'green');
text(500, 1.1, 'yellow');
text(650, 1.1, 'brown');
text(800, 1.1, 'red');
set(findobj(gcf, 'type', 'text'), 'hori', 'center');