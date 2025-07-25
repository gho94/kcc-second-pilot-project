document.getElementById("loginForm").addEventListener("submit", function (e) {
  e.preventDefault();

  const userId = document.getElementById("userId").value;
  const userPassword = document.getElementById("userPassword").value;

  if (!userId || !userPassword) {
    alert("아이디와 비밀번호를 모두 입력해주세요.");
    return;
  }
  
  this.submit();
});

// 입력 필드 포커스 효과
document.querySelectorAll(".form-control").forEach((input) => {
  input.addEventListener("focus", function () {
    this.parentElement.classList.add("focused");
  });

  input.addEventListener("blur", function () {
    if (!this.value) {
      this.parentElement.classList.remove("focused");
    }
  });
});
