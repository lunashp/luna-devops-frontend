// error.tsx

const Error = () => {
  // 🔴 Code Smell: 사용되지 않는 변수
  const unusedVariable = "I am never used";

  // 🔴 Security Hotspot + Bug: eval 사용
  eval("alert('this is insecure')");

  // 🔴 Bug: 정의되지 않은 변수 사용
  console.log(undefinedVar); // ReferenceError

  // 🔴 Code Smell: 너무 복잡한 함수
  function tooComplex() {
    if (true) {
      if (true) {
        if (true) {
          if (true) {
            if (true) {
              if (true) {
                console.log("tooComplex");
              }
            }
          }
        }
      }
    }
  }

  // 🔴 Duplicated code: 동일한 코드 블록 반복
  function duplicateCode() {
    const a = 1;
    const b = 2;
    console.log(a + b);
  }
  function duplicateCode2() {
    const a = 1;
    const b = 2;
    console.log(a + b); // 중복된 블록
  }

  // 🔴 Bug: async 함수 내부 await 없이 fetch
  async function asyncBug() {
    fetch("https://invalid.url"); // 경고 유도
  }

  // 🔴 Security Hotspot: hardcoded credentials
  const password = "123456";

  // 🔴 Code Smell: 너무 긴 함수
  function longFunction() {
    let sum = 0;
    for (let i = 0; i < 1000; i++) {
      sum += i;
    }
    return sum;
  }

  return (
    <div>
      <h1>Error</h1>
    </div>
  );
};

export default Error;
