# 🥗 BMI & Calorie Coach

A modern, comprehensive Flutter health & fitness application that calculates **Body Mass Index (BMI)**, **Basal Metabolic Rate (BMR)**, **Total Daily Energy Expenditure (TDEE)**, **Goal-based Daily Caloric Targets**, **Macronutrient Distributions**, and provides **Personalized Diet & Workout Suggestions**.

---

## ✨ Features

- **📊 Accurate BMI & Category Classification**:
  - Calculates BMI from height (feet & inches) and weight (kg).
  - Automatically identifies health status: *Underweight*, *Normal Weight*, *Overweight*, *Obesity Class I*, or *Obesity Class II+*.
  - Displays the ideal healthy weight range for your height.

- **🔥 Advanced Caloric & Metabolic Engine**:
  - **BMR (Basal Metabolic Rate)**: Clinically calculated via the **Mifflin-St Jeor** equation based on weight, height, age, and gender.
  - **TDEE (Total Daily Energy Expenditure)**: Estimates maintenance calories considering 5 physical activity levels (Sedentary to Extra Active).
  - **Target Calorie Customization**: Adjusts calories based on your personal goal (*Lose Weight*, *Mild Loss*, *Maintain*, *Mild Gain*, *Gain Muscle*).

- **🥗 Macronutrient & Hydration Breakdown**:
  - Exact gram, percentage, and calorie targets for **Carbohydrates**, **Protein**, and **Healthy Fats**.
  - Visual tri-color macronutrient distribution bar.
  - Recommended daily water intake (in Liters and 250ml glasses).

- **💡 Tailored Health & Lifestyle Suggestions**:
  - **Nutrition Strategy**: Specific dietary recommendations for your fitness goal.
  - **Food Lists**: Prioritized nutrient-dense whole foods vs. foods to limit or avoid.
  - **Exercise Routine**: Targeted workout plans (cardio, progressive resistance training, daily steps) tailored to BMI category.
  - **Daily Habits**: Guidance on restorative sleep (7–8 hours), hydration habits, and stress management.

- **🎨 Modern Material 3 UI/UX**:
  - Gender selector cards with responsive active highlights.
  - Intuitive input fields with validation and error feedback.
  - Summary hero card and interactive tabbed insights (*Calories & Macros*, *Suggestions*, *BMI Guide*).

---

## 🧮 Formulas & Calculation Methodology

### 1. Basal Metabolic Rate (BMR) — Mifflin-St Jeor Equation
- **For Men:**
  $$\text{BMR} = (10 \times \text{weight in kg}) + (6.25 \times \text{height in cm}) - (5 \times \text{age}) + 5$$
- **For Women:**
  $$\text{BMR} = (10 \times \text{weight in kg}) + (6.25 \times \text{height in cm}) - (5 \times \text{age}) - 161$$

### 2. Total Daily Energy Expenditure (TDEE)
$$\text{TDEE} = \text{BMR} \times \text{Activity Multiplier}$$

| Activity Level | Multiplier | Description |
| :--- | :---: | :--- |
| **Sedentary** | `1.2` | Little or no exercise, desk job |
| **Lightly Active** | `1.375` | Light exercise 1–3 days/week |
| **Moderately Active** | `1.55` | Moderate exercise 3–5 days/week |
| **Very Active** | `1.725` | Hard exercise 6–7 days/week |
| **Extra Active** | `1.9` | Very intense physical training / job |

### 3. Goal-Driven Daily Calorie Targets
- **Weight Loss**: $\text{TDEE} - 500\text{ kcal}$ (~0.5 kg loss/week)
- **Mild Weight Loss**: $\text{TDEE} - 250\text{ kcal}$ (~0.25 kg loss/week)
- **Maintenance**: $\text{TDEE}$
- **Mild Weight Gain**: $\text{TDEE} + 250\text{ kcal}$ (~0.25 kg gain/week)
- **Weight / Muscle Gain**: $\text{TDEE} + 500\text{ kcal}$ (~0.5 kg gain/week)

---

## 📁 Project Structure

```text
lib/
├── main.dart                       # App entry point with Material 3 Teal theme
├── bmi_calculator.dart             # Main screen with form inputs & tabbed results
├── catagory_card.dart              # Reusable category range card with highlight
├── models/
│   └── health_models.dart          # Data models, Enums, and Result structures
├── utils/
│   └── health_calculator.dart      # Pure calculation engine (BMR, TDEE, Macros, Tips)
└── widgets/
    ├── macro_nutrient_card.dart    # Daily calories, macros progress bar & water intake
    └── suggestions_view.dart       # Diet strategy, food tags, and exercise plan
test/
├── health_calculator_test.dart     # Unit test suite for calculations & suggestions
└── widget_test.dart                # App smoke & UI widget test
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `>= 3.12.0`)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code / Antigravity IDE with Flutter extension

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/bmi_with_calorie.git
   cd bmi_with_calorie
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

4. **Execute tests:**
   ```bash
   flutter test
   ```

---

## 🧪 Testing

Unit tests and widget tests are located in the `test/` directory.

```bash
flutter test test/health_calculator_test.dart
```

**Test Coverage Highlights:**
- Height conversion from imperial (feet/inches) to metric (cm/meters)
- BMI formula and category classification
- Mifflin-St Jeor BMR for both Male and Female
- TDEE and goal calorie calculations
- Macronutrient splits (grams, percentages, calories)
- Suggestion generation and water intake calculations
- Widget smoke test for the home screen

---

## 🛠️ Built With

- **[Flutter](https://flutter.dev/)** - Cross-platform UI toolkit
- **[Dart](https://dart.dev/)** - Modern client-optimized programming language
- **Material 3 Design** - Expressive and accessible UI components

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
