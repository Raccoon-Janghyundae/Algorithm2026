import java.util.Stack;

String inputText = "";
String displayedInfix = "";
String displayedPostfix = "";
String displayedResult = "";

PFont font;

void setup() {
  size(600, 350);
  font = createFont("Malgun Gothic", 16);
  textFont(font);
}

void draw() {
  background(245);
  
  fill(0);
  textSize(14);
  text("수식을 입력하고 Enter를 누르세요 (예: 3 + 5 * ( 2 - 8 ) )", 30, 40);
  fill(100);
  text("※ 숫자, 연산자, 괄호 사이에 공백을 꼭 넣어주세요", 30, 60);

  stroke(200);
  fill(255);
  rect(30, 80, 540, 35, 5);
  
  fill(0);
  textSize(16);
  text(inputText + "|", 40, 103);

  fill(80);
  textSize(15);
  text("입력한 중위 표기식 (Infix): " + displayedInfix, 30, 155);

  fill(50, 100, 220);
  text("변환된 후위 표기식 (Postfix): " + displayedPostfix, 30, 195);

  fill(200, 30, 30);
  textSize(18);
  text("최종 계산 결과: " + displayedResult, 30, 245);
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    if (inputText.trim().length() > 0) {
      displayedInfix = inputText;
      displayedPostfix = infixToPostfix(displayedInfix);
      try {
        float res = evaluatePostfix(displayedPostfix);
        displayedResult = String.valueOf(res);
      } catch (Exception e) {
        displayedResult = "오류 (입력 형식을 확인하세요)";
      }
    }
  } else if (key == BACKSPACE) {
    if (inputText.length() > 0) {
      inputText = inputText.substring(0, inputText.length() - 1);
    }
  } else if (key != CODED) {
    inputText += key;
  }
}

int precedence(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  return -1;
}

boolean isOperator(String t) {
  return t.equals("+") || t.equals("-") || t.equals("*") || t.equals("/");
}

float value(String t) {
  return Float.parseFloat(t);
}

String infixToPostfix(String infix) {
  StringBuilder result = new StringBuilder();
  Stack<String> stack = new Stack<String>();
  String[] tokens = infix.trim().split("\\s+");

  for (String t : tokens) {
    if (t.isEmpty()) continue;

    if (t.equals("(")) {
      stack.push(t);
    } else if (t.equals(")")) {
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        result.append(stack.pop()).append(" ");
      }
      if (!stack.isEmpty()) stack.pop();
    } else if (isOperator(t)) {
      while (!stack.isEmpty() && precedence(t) <= precedence(stack.peek())) {
        result.append(stack.pop()).append(" ");
      }
      stack.push(t);
    } else {
      result.append(t).append(" ");
    }
  }

  while (!stack.isEmpty()) {
    result.append(stack.pop()).append(" ");
  }

  return result.toString().trim();
}

float evaluatePostfix(String postfix) {
  Stack<Float> st = new Stack<Float>();
  String[] tokens = postfix.trim().split("\\s+");

  for (String t : tokens) {
    if (t.isEmpty()) continue;

    if (t.equals("+")) {
      float b = st.pop();
      float a = st.pop();
      st.push(a + b);
    } else if (t.equals("-")) {
      float b = st.pop();
      float a = st.pop();
      st.push(a - b);
    } else if (t.equals("*")) {
      float b = st.pop();
      float a = st.pop();
      st.push(a * b);
    } else if (t.equals("/")) {
      float b = st.pop();
      float a = st.pop();
      st.push(a / b);
    } else {
      st.push(value(t));
    }
  }

  return st.pop();
}
