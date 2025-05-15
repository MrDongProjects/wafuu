import 'package:flutter/material.dart';
import 'package:wafu_bunpo/theme/app_theme.dart';

class GrammarPracticePage extends StatefulWidget {
  final String level;
  final List<Map<String, dynamic>> studiedGrammar;

  const GrammarPracticePage({
    super.key,
    required this.level,
    required this.studiedGrammar,
  });

  @override
  State<GrammarPracticePage> createState() => _GrammarPracticePageState();
}

class _GrammarPracticePageState extends State<GrammarPracticePage> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _showResult = false;
  String? _selectedAnswer;

  // 模拟练习题数据
  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'multiple_choice',
      'grammar': 'は',
      'question': '选择正确的句子：',
      'sentence': '私__学生です。',
      'options': ['が', 'は', 'を', 'に'],
      'correct': 'は',
      'explanation': '表示主题时使用は。',
    },
    {
      'type': 'sentence_arrangement',
      'grammar': 'です',
      'question': '将下列单词排列成正确的句子：',
      'words': ['先生', 'です', 'あの人', 'は'],
      'correct': 'あの人は先生です',
      'explanation': '日语句子的基本语序是"主语 + は + 名词 + です"。',
    },
    {
      'type': 'translation',
      'grammar': 'が',
      'question': '翻译成日语：',
      'sentence': '下雨了。',
      'correct': '雨が降っています。',
      'hint': '使用"雨"和"が"来表达。',
      'explanation': '自然现象通常使用が来引入主语。',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTheme.lanternEmoji),
            const SizedBox(width: 8),
            Text('${widget.level}语法练习'),
          ],
        ),
        actions: [
          _buildProgress(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).cardColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildQuestionCard(),
                    if (_showResult) ...[
                      const SizedBox(height: 20),
                      _buildExplanationCard(),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.wasabiGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppTheme.wasabiGreen,
          ),
          const SizedBox(width: 4),
          Text(
            '$_correctAnswers/${_questions.length}',
            style: TextStyle(
              color: AppTheme.wasabiGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestionIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.wasabiGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question['grammar'],
                  style: TextStyle(
                    color: AppTheme.wasabiGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '第${_currentQuestionIndex + 1}题',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildQuestionContent(question),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(Map<String, dynamic> question) {
    switch (question['type']) {
      case 'multiple_choice':
        return _buildMultipleChoice(question);
      case 'sentence_arrangement':
        return _buildSentenceArrangement(question);
      case 'translation':
        return _buildTranslation(question);
      default:
        return const SizedBox();
    }
  }

  Widget _buildMultipleChoice(Map<String, dynamic> question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['sentence'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          question['options'].length,
          (index) => _buildOptionButton(
            question['options'][index],
            question['correct'],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option, String correct) {
    final isSelected = option == _selectedAnswer;
    final isCorrect = _showResult && option == correct;
    final isWrong = _showResult && isSelected && option != correct;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap:
            _showResult ? null : () => setState(() => _selectedAnswer = option),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCorrect
                ? AppTheme.wasabiGreen.withOpacity(0.1)
                : isWrong
                    ? Colors.red.withOpacity(0.1)
                    : isSelected
                        ? AppTheme.wasabiGreen.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect
                  ? AppTheme.wasabiGreen
                  : isWrong
                      ? Colors.red
                      : isSelected
                          ? AppTheme.wasabiGreen
                          : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : null,
                  color: isCorrect
                      ? AppTheme.wasabiGreen
                      : isWrong
                          ? Colors.red
                          : null,
                ),
              ),
              const Spacer(),
              if (_showResult)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? AppTheme.wasabiGreen : Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSentenceArrangement(Map<String, dynamic> question) {
    final words = List<String>.from(question['words']);
    final List<String> arrangedWords = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['sentence'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.map((word) {
            final isSelected = arrangedWords.contains(word);
            return InkWell(
              onTap: _showResult
                  ? null
                  : () {
                      setState(() {
                        if (isSelected) {
                          arrangedWords.remove(word);
                        } else {
                          arrangedWords.add(word);
                        }
                        _selectedAnswer = arrangedWords.join('');
                      });
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.wasabiGreen.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.wasabiGreen
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    color: isSelected ? AppTheme.wasabiGreen : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (arrangedWords.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.wasabiGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              arrangedWords.join(''),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.wasabiGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTranslation(Map<String, dynamic> question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['sentence'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          enabled: !_showResult,
          onChanged: (value) => setState(() => _selectedAnswer = value),
          decoration: InputDecoration(
            hintText: question['hint'] ?? '请输入日语翻译',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.wasabiGreen,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 16),
          maxLines: 3,
        ),
        if (_showResult) ...[
          const SizedBox(height: 16),
          Text(
            '参考答案：',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question['correct'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExplanationCard() {
    final question = _questions[_currentQuestionIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _selectedAnswer == question['correct']
                    ? Icons.check_circle
                    : Icons.cancel,
                color: _selectedAnswer == question['correct']
                    ? AppTheme.wasabiGreen
                    : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                _selectedAnswer == question['correct'] ? '回答正确！' : '回答错误',
                style: TextStyle(
                  color: _selectedAnswer == question['correct']
                      ? AppTheme.wasabiGreen
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '解释',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            question['explanation'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (!_showResult) {
      return _buildGradientButton(
        '确认答案',
        onTap: () {
          if (_selectedAnswer == null) return;
          setState(() {
            _showResult = true;
            if (_selectedAnswer ==
                _questions[_currentQuestionIndex]['correct']) {
              _correctAnswers++;
            }
          });
        },
      );
    }

    return _buildGradientButton(
      _currentQuestionIndex < _questions.length - 1 ? '下一题' : '完成练习',
      onTap: () {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _showResult = false;
            _selectedAnswer = null;
          });
        } else {
          // TODO: 显示练习结果页面
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildGradientButton(String text, {required VoidCallback onTap}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.wasabiGreen,
            Color(0xFF8BBF4D),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.wasabiGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
