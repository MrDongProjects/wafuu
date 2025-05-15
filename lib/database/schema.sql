-- -----------------------------------------------------
-- Table `users` - 用户信息表
-- 存储用户的基本信息和登录状态
-- -----------------------------------------------------
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    avatar VARCHAR(255) COMMENT '头像路径',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
    last_login_at TIMESTAMP NULL COMMENT '最后登录时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- -----------------------------------------------------
-- Table `search_history` - 搜索历史表
-- 记录用户的搜索记录，包括搜索的单词和查询结果
-- -----------------------------------------------------
CREATE TABLE search_history (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '搜索记录ID',
    user_id INT COMMENT '用户ID',
    keyword VARCHAR(100) NOT NULL COMMENT '搜索的单词/语法',
    romaji VARCHAR(100) COMMENT '罗马音',
    meaning TEXT COMMENT '中文含义',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '搜索时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='搜索历史记录表';

-- -----------------------------------------------------
-- Table `favorites` - 收藏单词表
-- 存储用户收藏的单词及其详细信息
-- -----------------------------------------------------
CREATE TABLE favorites (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '收藏记录ID',
    user_id INT COMMENT '用户ID',
    word VARCHAR(100) NOT NULL COMMENT '日语单词',
    reading VARCHAR(100) COMMENT '读音',
    meaning TEXT COMMENT '含义',
    level VARCHAR(2) COMMENT 'JLPT等级 (N1-N5)',
    word_type VARCHAR(20) COMMENT '词性(名词、动词等)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏单词表';

-- -----------------------------------------------------
-- Table `study_stats` - 学习统计表
-- 记录用户每日学习情况和进度
-- -----------------------------------------------------
CREATE TABLE study_stats (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '统计记录ID',
    user_id INT COMMENT '用户ID',
    date DATE NOT NULL COMMENT '学习日期',
    words_learned INT DEFAULT 0 COMMENT '当日学习的单词数',
    time_spent INT DEFAULT 0 COMMENT '学习时长(分钟)',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习统计表';

-- -----------------------------------------------------
-- Table `study_plans` - 学习计划表
-- 存储用户制定的学习计划和目标
-- -----------------------------------------------------
CREATE TABLE study_plans (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '计划ID',
    user_id INT COMMENT '用户ID',
    title VARCHAR(100) NOT NULL COMMENT '计划标题',
    target_level VARCHAR(2) COMMENT '目标等级',
    daily_word_goal INT COMMENT '每日单词目标数量',
    start_date DATE COMMENT '计划开始日期',
    end_date DATE COMMENT '计划结束日期',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习计划表';

-- -----------------------------------------------------
-- Table `exam_records` - 考试记录表
-- 记录用户的模拟考试成绩和详情
-- -----------------------------------------------------
CREATE TABLE exam_records (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '考试记录ID',
    user_id INT COMMENT '用户ID',
    exam_type VARCHAR(2) NOT NULL COMMENT '考试类型(N1-N5)',
    score INT COMMENT '考试得分',
    total_questions INT COMMENT '考试总题数',
    correct_answers INT COMMENT '正确答题数',
    exam_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '考试时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试记录表';

-- -----------------------------------------------------
-- Table `words` - 单词表
-- 系统基础词库，包含单词详细信息和例句
-- -----------------------------------------------------
CREATE TABLE words (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '单词ID',
    word VARCHAR(100) NOT NULL COMMENT '日语单词',
    reading VARCHAR(100) COMMENT '读音',
    meaning TEXT COMMENT '中文含义',
    level VARCHAR(2) COMMENT 'JLPT等级',
    word_type VARCHAR(20) COMMENT '词性',
    example_sentences TEXT COMMENT '示例句子(JSON格式存储)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='单词基础词库表';

-- -----------------------------------------------------
-- Table `feedback` - 用户反馈表
-- -----------------------------------------------------
CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '反馈ID',
    user_id INT COMMENT '用户ID',
    content TEXT NOT NULL COMMENT '反馈内容',
    contact VARCHAR(100) COMMENT '联系方式',
    status TINYINT DEFAULT 0 COMMENT '处理状态：0未处理，1已处理',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户反馈表';

-- -----------------------------------------------------
-- 索引设置
-- 优化查询性能
-- -----------------------------------------------------
CREATE INDEX idx_search_history_user_id ON search_history(user_id) COMMENT '用户搜索历史索引';
CREATE INDEX idx_search_history_keyword ON search_history(keyword) COMMENT '搜索关键词索引';
CREATE INDEX idx_favorites_user_id ON favorites(user_id) COMMENT '用户收藏索引';
CREATE INDEX idx_favorites_word ON favorites(word) COMMENT '收藏单词索引';
CREATE INDEX idx_study_stats_user_id_date ON study_stats(user_id, date) COMMENT '用户学习统计索引';
CREATE INDEX idx_words_level ON words(level) COMMENT '单词等级索引'; 