# Contributing Guidelines

- Please consider raising an issue before submitting a pull request (PR) to solve a problem that is not present in our [issue tracker](https://github.com/bharat-1809/JustSplit/issues). This allows maintainers to first validate the issue you are trying to solve and also reference the PR to a specific issue.
- When submitting a PR, please follow [this template](.github/PULL_REQUEST_TEMPLATE.md) (which will probably be already filled up once you create the PR).
- Use only the latest beta version of Flutter.
- When submitting a PR with changes to user interface (e.g.: new screen, ...), please add screenshots to the PR description.
- When you are finished with your work, please squash your commits otherwise we will squash them on your PR (this can help us maintain a clear commit history).
- Issues labeled as “First Timers Only” are meant for contributors who have not contributed to the project yet. Please choose other issues to contribute to, if you have already contributed to these type of issues.

## General Guidelines

- If you’re just getting started work on an issue labeled “First Timers Only” in any project.
- In an active repository (not an archived one), choose an open issue from the issue list, claim it in the comments, and a maintainer will assign it to you.
- After approval you must make continuous notes on your progress in the issue while working. If there is not at least one comment every 3 days, the maintainer can reassign the issue.
- Create a branch specific to the issue you're working on, so that you send a PR from that branch instead of the base branch on your fork.
- If you’d like to create a new issue, please go through our issue list first (open as well as closed) and make sure the issues you are reporting do not replicate the existing issues.
- Have a short description on what has gone wrong (like a root cause analysis and description of the fix), if that information is not already present in the issue.
- If you have issues on multiple pages, report them separately. Do not combine them into a single issue.

## Code style guidelines

Dart language has the default [`dartfmt`](https://github.com/dart-lang/dart_style) tool to enforce style. It's great and we stick to it to avoid [bikeshedding](https://en.wikipedia.org/wiki/Law_of_triviality).

Apart from [formatting your code using `dartfmt`](https://flutter.dev/docs/development/tools/formatting), you must:

- Set column line width to 100 in your IDE. 80 is simply too short. How to? Look below:
  **Android Studio/IntelliJ**:
  <img width="964" alt="JetBrains format" src="https://user-images.githubusercontent.com/40357511/79511535-c3883500-803f-11ea-97d4-b9264ed87d74.png">

  **Visual Studio Code**:
  <img width="964" alt="VSCode format" src="https://user-images.githubusercontent.com/40357511/80772789-21e10780-8b58-11ea-9e22-7ebdf0b61977.png">


- When you want to print something to the console, *do not* use `print()`; use `logger` instead. You should also use appropriate log level. Example:
    ```
    if (token != null) {
          logger.i("Found a token.");
        } else {
          logger.e("Error: no token!");
        }
    ```

- To create reusable pieces of UI, create a new class extending `StatelessWidget`. Do not create functions returning `Widget`.
  [Why?](https://stackoverflow.com/questions/53234825/what-is-the-difference-between-functions-and-classes-to-create-reusable-widgets)

  Example of **bad code**

  ```
  Widget _buildSomeWidgets(BuildContext context) {
    return Center(
      child: Text("Hi!"),
    );
  }
  ```

  Example of **good code**

  ```
  class _SomeWidgets extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Center(
        child: Text("Hi!"),
      );
    }
  }
  ```
