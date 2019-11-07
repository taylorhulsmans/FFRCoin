// time multiple of phi
//
// golden annum
// 
const now = new Date()
const nowPosix = now.getTime() / 1000
const dayInS = 3600 * 24
const yearYearInS = dayInS * 365

// A = P(1 + i/365) ^t/365
Math.phi = (1 + Math.sqrt(5)) / 2;
let i = 0
while (i < 2) {
  console.log(Math.pow(Math.phi, i), Math.pow(Math.phi, i+1))

  const expression = (1 / Math.phi) + 
  i++
}

const a = (1 /Math.phi)
const b = 1 - a
const c = b*a
const d = a + c
console.log(a, b, c, d)
