const icon = document.getElementById("profileIcon");
   const modal = document.getElementById("profileModal");
   const closeMobileNav = document.getElementById("closeMobileNav");
   const burgerBtn = document.getElementById("burgerBtn");
   const mobileNav = document.getElementById("mobileNav");

   const menuWraps = document.querySelectorAll(".menu-wrap");
   const sections = document.querySelectorAll(".menu-section");
   const mobileMenuTitles = document.querySelectorAll(
     "#mobileNav .menu-title"
   );

   // 프로필 아이콘 클릭 시 모달 토글
   icon.addEventListener("click", function (e) {
     modal.style.display = modal.style.display === "block" ? "none" : "block";
     e.stopPropagation(); // 외부 클릭 감지를 위해
   });

   // 외부 클릭 시 프로필 모달 닫기
   document.addEventListener("click", function () {
     modal.style.display = "none";
   });

   // PC 메뉴 hover로 서브메뉴 열기/닫기
   menuWraps.forEach((wrap) => {
     wrap.addEventListener("mouseenter", () => {
       menuWraps.forEach((w) => w.classList.remove("active"));
       wrap.classList.add("active");
     });

     wrap.addEventListener("mouseleave", () => {
       wrap.classList.remove("active");
     });
   });

   // 모바일 햄버거 버튼 열기
   burgerBtn.addEventListener("click", function (e) {
     mobileNav.classList.toggle("open");
     e.stopPropagation();
   });

   // 모바일 메뉴 외부 클릭 시 닫기
   document.addEventListener("click", function () {
     mobileNav.classList.remove("open");
   });

   // 모바일 메뉴 각 항목 토글
   mobileMenuTitles.forEach((title) => {
     title.addEventListener("click", function (e) {
       e.stopPropagation();
       this.classList.toggle("open");

       // 다른 메뉴 닫기 (선택적)
       mobileMenuTitles.forEach((other) => {
         if (other !== this) {
           other.classList.remove("open");
         }
       });
     });
   });

   // 모바일 메뉴 닫기 버튼
   closeMobileNav.addEventListener("click", function (e) {
     e.stopPropagation();
     mobileNav.classList.remove("open");
   });

   // 모바일 메뉴의 섹션별 서브메뉴 toggle
   sections.forEach((section) => {
     section.querySelector(".menu-title").addEventListener("click", () => {
       sections.forEach((s) => {
         if (s !== section) s.classList.remove("active");
       });

       section.classList.toggle("active");
     });
   });